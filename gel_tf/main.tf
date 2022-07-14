terraform {
}

provider "google" {
  credentials = file(var.gcp_svc_acc_file_path)

  project = var.gcp_project_id
  region  = var.gcp_region
}

resource "google_service_account" "default" {
  account_id   = var.gcp_service_account_name
  display_name = "Manages the GEL cluster"
}

resource "google_service_account_key" "gcp_sa_key" {
  service_account_id = google_service_account.default.email
  depends_on = [
    google_service_account.default
  ]
}

resource "google_container_cluster" "primary" {
  name               = var.gcp_gel_gke_cluster_name
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

resource "google_storage_bucket" "gel_storage" {
  name          = var.gcp_gcs_bucket_name
  location      = var.gcp_region
  force_destroy = true
  labels = {
    owner = var.owner_name
  }
}

resource "google_storage_bucket_iam_binding" "binding" {
  bucket = google_storage_bucket.gel_storage.name
  role   = "roles/storage.admin"
  members = [
    "serviceAccount:${google_service_account.default.email}"
  ]

  depends_on = [
    google_storage_bucket.gel_storage,
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

resource "kubernetes_secret" "gel_secrets" {
  metadata {
    name = "gel-secrets"
  }
  data = {
    "gcp_service_account.json" = base64decode(google_service_account_key.gcp_sa_key.private_key)
    "gel-license.jwt"     =  var.gel_license_contents
  }

  depends_on = [
    google_container_cluster.primary
  ]
}

resource "helm_release" "gel" {
  chart      = "loki-simple-scalable"
  name       = var.gel_cluster_name
  repository = "https://grafana.github.io/helm-charts"

  values = [
    templatefile("${path.module}/gel_values.tftpl", {
      gel_cluster_name = var.gel_cluster_name
      bucket_name      = var.gcp_gcs_bucket_name
    })
  ]

  depends_on = [
    google_container_cluster.primary,
    kubernetes_secret.gel_secrets
  ]
}