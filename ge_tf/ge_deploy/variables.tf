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

variable "owner_name" {
  type    = string
  default = "alexkirtleyclose"
}

variable "gke_cluster_name" {
  type    = string
  default = "akc-gem"
}

variable "ge_ip_address" {
  type = string
}

variable "ge_license_contents" {
  type = string
}

variable "ge_deployment_name" {
  type    = string
  default = "ge"
}