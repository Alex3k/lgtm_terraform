## How to deploy GEL
Please either update the default values within variables.tf or overide them when using the apply command. For example:
`terraform apply -var gel_license_file="" -var gcp_service_account_name="" -var gcp_gel_gke_cluster_name="" -var gcp_gcs_bucket_name="" -var owner_name="" -var gcp_svc_acc_file_path=""`

You will need a service account which has editor permissions to a GCP project. This is as the follow items will be created: a GCS bucket, K8s cluster and a service account. Please download the service account file and use the `gcp_svc_acc_file_path` variable to point to it

To deploy GEL, simply run:
- `terraform init`
- `terraform validate`
- `terraform apply -var gel_license_file="" -var gcp_service_account_name="" -var gcp_gel_gke_cluster_name="" -var gcp_gcs_bucket_name="" -var owner_name="" -var gcp_svc_acc_file_path=""`

### Extracting the token
At the end of the command, you will need to get the token from the `tokengen` pod. As it stands, I can't work out how to automate this as part of the Terraform script. So you will need to connect to the GKE cluster and then get the logs of that pod. Within the logs will be a line that begin with "Token:". Copy this token and save it for later.


