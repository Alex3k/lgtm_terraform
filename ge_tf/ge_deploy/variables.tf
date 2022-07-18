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

variable "owner_name" {
  type        = string
  description = "Your name in lowercase and without spaces for GCP resource identification purposes."
  nullable    = false
}

variable "gke_cluster_name" {
  type        = string
  description = "The GKE cluster that you want to connect to and deploy GE into."
  nullable    = false
}

variable "ge_ip_address" {
  type        = string
  description = "The IP address that GE will be using which is outputted from the env_setup process"
  nullable    = false
}

variable "ge_license_file" {
  type        = string
  description = "The file path to the GE license file."
  nullable    = false

  validation {
    condition     = fileexists(var.ge_license_file)
    error_message = "The file must exist"
  }
}

variable "ge_deployment_name" {
  type        = string
  default     = "ge"
  description = "The Kubernetes Deployment name for GE"
  nullable    = false

}