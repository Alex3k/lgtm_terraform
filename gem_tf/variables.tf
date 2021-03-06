variable "gcp_project_id" {
  type        = string
  default     = "solutions-engineering-248511"
  description = "The GCP Project ID to use for this deployment"
  nullable    = false
}

variable "gcp_svc_acc_file_path" {
  type        = string
  description = "The path to a GCP service account JSON license file which has Editor permissions to the GCP project"
  nullable    = false
  validation {
    condition     = fileexists(var.gcp_svc_acc_file_path)
    error_message = "The file must exist"
  }
}

variable "gcp_region" {
  type        = string
  default     = "us-central1"
  description = "The region to deploy everything in"
  nullable    = false
}

variable "gcp_service_account_name" {
  type        = string
  description = "The service account name that will be created as part of this process. Must be unique."
  nullable    = false
}

variable "gcp_gem_gke_cluster_name" {
  type        = string
  description = "The GKE cluster that will be created as part of this process. Must be unique."
  nullable    = false
}

variable "gcp_gcs_bucket_prefix" {
  type        = string
  description = "This process created three buckets with the postfix's tsdb, ruler and admit. What should the prefix to these buckets be?"
  nullable    = false
}

variable "owner_name" {
  type        = string
  description = "Your name in lowercase and without spaces for GCP resource identification purposes."
  nullable    = false
}

variable "gem_cluster_name" {
  type        = string
  description = "The name of the GEM deployment that will be created as part of this process."
  nullable    = false
}

variable "gem_license_file" {
  type        = string
  description = "The file path to the GEM license file."
  nullable    = false

  validation {
    condition     = fileexists(var.gem_license_file)
    error_message = "The file must exist"
  }
}