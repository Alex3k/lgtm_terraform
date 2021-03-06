variable "gcp_svc_acc_file_path" {
  type        = string
  description = "The path to a GCP service account JSON license file which has Editor permissions to the GCP project"
  nullable    = false
  validation {
    condition     = fileexists(var.gcp_svc_acc_file_path)
    error_message = "The file must exist"
  }
}

variable "gcp_project_id" {
  type        = string
  default     = "solutions-engineering-248511"
  description = "The GCP Project ID to use for this deployment"
  nullable    = false
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

variable "gcp_gel_gke_cluster_name" {
  type        = string
  description = "The GKE cluster that will be created as part of this process. Must be unique."
  nullable    = false
}

variable "gcp_gcs_bucket_name" {
  type        = string
  description = "The GCS bucket that will be created as part of this process. Must be unique."
  nullable    = false
}

variable "owner_name" {
  type        = string
  description = "Your name in lowercase and without spaces for GCP resource identification purposes."
  nullable    = false
}

variable "gel_cluster_name" {
  type        = string
  description = "The name of the GEL deployment that will be created as part of this process."
  nullable    = false
}

variable "gel_license_file" {
  type        = string
  description = "The file path to the GEL license file."
  nullable    = false

  validation {
    condition     = fileexists(var.gel_license_file)
    error_message = "The file must exist"
  }
}