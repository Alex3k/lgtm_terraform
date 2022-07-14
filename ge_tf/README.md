## Deploying GE
Having a fully automated GE deployment is slightly more complicated as we need to know the URL of Grafana before we deploy. Therefore we use the following steps
- Use the `env_setup` Terraform folder to get the IP address for Grafana, then give that URL to a Grafana Labs team member to get your license which requires the IP address.
- Use the `ge_deploy` Terraform folder to deploy GE using that IP address
