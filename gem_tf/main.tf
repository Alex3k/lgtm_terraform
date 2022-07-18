terraform {
}

provider "google" {
  credentials = file(var.gcp_svc_acc_file_path)

  project = var.gcp_project_id
  region  = var.gcp_region
}

resource "google_service_account" "default" {
  account_id   = var.gcp_service_account_name
  display_name = "Manages the GEM cluster"
}

resource "google_service_account_key" "gcp_sa_key" {
  service_account_id = google_service_account.default.email
  depends_on = [
    google_service_account.default
  ]
}

resource "google_container_cluster" "primary" {
  name               = var.gcp_gem_gke_cluster_name
  location           = var.gcp_region
  initial_node_count = 3
  resource_labels = {
    owner = var.owner_name
  }
  node_config {
    service_account = google_service_account.default.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    labels = {
      owner = var.owner_name
    }
  }
}

resource "google_storage_bucket" "gem_storage_admin" {
  name          = "${var.gcp_gcs_bucket_prefix}-admin"
  location      = var.gcp_region
  force_destroy = true
  labels = {
    owner = var.owner_name
  }
}

resource "google_storage_bucket" "gem_storage_ruler" {
  name          = "${var.gcp_gcs_bucket_prefix}-ruler"
  location      = var.gcp_region
  force_destroy = true
  labels = {
    owner = var.owner_name
  }
}

resource "google_storage_bucket" "gem_storage_tsdb" {
  name          = "${var.gcp_gcs_bucket_prefix}-tsdb"
  location      = var.gcp_region
  force_destroy = true
  labels = {
    owner = var.owner_name
  }
}

resource "google_storage_bucket_iam_binding" "admin_binding" {
  bucket = google_storage_bucket.gem_storage_admin.name
  role   = "roles/storage.admin"
  members = [
    "serviceAccount:${google_service_account.default.email}"
  ]

  depends_on = [
    google_storage_bucket.gem_storage_admin,
    google_service_account_key.gcp_sa_key
  ]
}

resource "google_storage_bucket_iam_binding" "ruler_binding" {
  bucket = google_storage_bucket.gem_storage_ruler.name
  role   = "roles/storage.admin"
  members = [
    "serviceAccount:${google_service_account.default.email}"
  ]

  depends_on = [
    google_storage_bucket.gem_storage_ruler,
    google_service_account_key.gcp_sa_key
  ]
}

resource "google_storage_bucket_iam_binding" "tsdb_binding" {
  bucket = google_storage_bucket.gem_storage_tsdb.name
  role   = "roles/storage.admin"
  members = [
    "serviceAccount:${google_service_account.default.email}"
  ]

  depends_on = [
    google_storage_bucket.gem_storage_tsdb,
    google_service_account_key.gcp_sa_key
  ]
}

module "gke_auth" {
  source = "terraform-google-modules/kubernetes-engine/google//modules/auth"

  project_id           = var.gcp_project_id
  cluster_name         = google_container_cluster.primary.name
  location             = google_container_cluster.primary.location
  use_private_endpoint = true

  depends_on = [
    google_container_cluster.primary
  ]
}

provider "kubernetes" {
  host  = google_container_cluster.primary.endpoint
  token = module.gke_auth.token
  cluster_ca_certificate = base64decode(
    google_container_cluster.primary.master_auth[0].cluster_ca_certificate
  )
}

provider "helm" {
  kubernetes {
    host  = google_container_cluster.primary.endpoint
    token = module.gke_auth.token
    cluster_ca_certificate = base64decode(
      google_container_cluster.primary.master_auth[0].cluster_ca_certificate
    )
  }
}

resource "kubernetes_secret" "gem_secrets" {
  metadata {
    name = "gem-secrets"
  }
  data = {
    "gcp_service_account.json" = base64decode(google_service_account_key.gcp_sa_key.private_key)
    "gem_license.jwt"          = file(var.gem_license_file)
  }

  depends_on = [
    google_container_cluster.primary
  ]
}

resource "helm_release" "gem" {
  chart      = "mimir-distributed"
  name       = var.gem_cluster_name
  repository = "https://grafana.github.io/helm-charts"

  values = [
    templatefile("${path.module}/gem_values.tftpl", {
      gem_cluster_name   = var.gem_cluster_name
      bucket_name_prefix = var.gcp_gcs_bucket_prefix
    })
  ]

  depends_on = [
    google_container_cluster.primary,
    kubernetes_secret.gem_secrets
  ]
}

output "kubectl_cmd" {
  value = "gcloud container clusters get-credentials ${var.gcp_gem_gke_cluster_name} --region ${var.gcp_region} --project ${var.gcp_project_id}"
}
