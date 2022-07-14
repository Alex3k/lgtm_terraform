terraform {

}

provider "google" {
  credentials = file(var.gcp_svc_acc_file_path)

  project = var.gcp_project_id
  region  = var.gcp_region
}

resource "google_compute_address" "ge_ip_address" {
  name   = "${var.owner_name}-${var.gem_cluster_name}-ip"
  region = var.gcp_region
}

output "ge_ip_address" {
  value = google_compute_address.ge_ip_address.address
}
