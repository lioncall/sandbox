terraform init
terraform validate
terraform workspace new Development
terraform plan -out development.tfplan
terraform apply "development.tfplan"

terraform destroy 

 