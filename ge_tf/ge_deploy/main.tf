terraform {
}

provider "google" {
  credentials = file(var.gcp_svc_acc_file_path)

  project = var.gcp_project_id
  region  = var.gcp_region
}

module "gke_auth" {
  source = "terraform-google-modules/kubernetes-engine/google//modules/auth"

  project_id   = var.gcp_project_id
  cluster_name = var.gke_cluster_name
  location     = var.gcp_region
}

provider "kubernetes" {
  host                   = module.gke_auth.host
  token                  = module.gke_auth.token
  cluster_ca_certificate = module.gke_auth.cluster_ca_certificate
}

provider "helm" {
  kubernetes {
    host                   = module.gke_auth.host
    token                  = module.gke_auth.token
    cluster_ca_certificate = module.gke_auth.cluster_ca_certificate
  }
}

resource "random_password" "ge_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "kubernetes_secret" "ge_secrets" {
  metadata {
    name = "ge-secrets"
  }
  data = {
    "license.jwt"    = file(var.ge_license_file)
    "admin_user"     = "admin"
    "admin_password" = random_password.ge_password.result
  }
}

resource "helm_release" "ge" {
  chart      = "grafana"
  name       = var.ge_deployment_name
  repository = "https://grafana.github.io/helm-charts"

  values = [
    templatefile("${path.module}/ge_overrides.yaml", {
      ge_ip = var.ge_ip_address
    })
  ]

  depends_on = [
    kubernetes_secret.ge_secrets
  ]
}


output "grafana_ip" {
  value = "http://${var.ge_ip_address}:3000"
}

output "grafana_username" {
  value     = kubernetes_secret.ge_secrets.data.admin_user
  sensitive = true
}

output "grafana_password" {
  value     = random_password.ge_password.result
  sensitive = true
}