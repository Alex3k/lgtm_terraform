variable "gcp_svc_acc_file_path" {
  type    = string
  default = "gcp-svc-acc.json"
}

variable "gcp_project_id" {
  type    = string
  default = "solutions-engineering-248511"
}

variable "gcp_region" {
  type    = string
  default = "us-central1"
}

variable "gcp_service_account_name" {
  type    = string
  default = "akc-gel-sa"
}

variable "gcp_gel_gke_cluster_name" {
  type    = string
  default = "akc-gel"
}

variable "gcp_gcs_bucket_name" {
  type    = string
  default = "akc-gel"
}

variable "owner_name" {
  type    = string
  default = "alexkirtleyclose"
}

variable "gel_cluster_name" {
  type    = string
  default = "gel"
}

variable "gel_license_contents" {
  type    = string
}