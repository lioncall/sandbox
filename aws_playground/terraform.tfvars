key_name = "dev-virginia"

private_key_path = "dev-virginia.pem"

bucket_name_prefix = "hamster"

billing_code_tag = "ACCT8675309"

 
network_address_space = {
  Development = "10.0.0.0/16"
  UAT = "10.1.0.0/16"
  Production = "10.2.0.0/16"
}

instance_size = {
  Development = "t2.micro"
  UAT = "t2.micro"
  Production = "t2.micro"
}

subnet_count = {
  Development = 2
  UAT = 2
  Production = 3
}

max_instance_count = {
  Development = 2
  UAT = 2
  Production = 2
}
