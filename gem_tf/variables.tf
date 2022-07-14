
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
  default = "akc-gem-sa"
}

variable "gcp_gem_gke_cluster_name" {
  type    = string
  default = "akc-gem"
}

variable "gcp_gcs_bucket_prefix" {
  type    = string
  default = "akc-gem"
}

variable "owner_name" {
  type    = string
  default = "alexkirtleyclose"
}

variable "gem_cluster_name" {
  type    = string
  default = "gem"
}

variable "gem_license_contents" {
  type    = string
}
