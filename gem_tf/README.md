## How to deploy GEM
Please either update the default values within variables.tf or overide them when using the apply command. For example:
`terraform apply -var gem_license_contents="YOUR LICENSE STRING" -var gcp_service_account_name="" -var gcp_gem_gke_cluster_name="" -var gcp_gcs_bucket_prefix="" -var owner_name="" -var gcp_svc_acc_file_path=""`

You will need a service account which has editor permissions to a GCP project. This is as the following will be created: multiple GCS buckets, K8s cluster and a service account. Please download the service account file and point to it using the `gcp_svc_acc_file_path` variable

To deploy GEM, simply run:
- `terraform init`
- `terraform validate`
- `terraform apply -var gem_license_contents="YOUR LICENSE STRING" -var gcp_service_account_name="" -var gcp_gem_gke_cluster_name="" -var gcp_gcs_bucket_prefix="" -var owner_name="" -var gcp_svc_acc_file_path=""`

### Extracting the token
At the end of the command, you will need to get the token from the tokengen pod. As it stands, I can't work out how to automate this as part of the Terraform script. So you will need to connect to the GKE cluster and then get the logs of that pod. Within the logs will be a line that begin with "Token:". Copy this token and save it for later.

