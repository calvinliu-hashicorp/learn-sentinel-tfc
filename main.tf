provider "aws" {
  region = var.region
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "random_pet" "name" {
  length    = 4
  separator = "-"
  prefix    = "pet"
}

locals {
  service_name = "forum"
  owner        = "Community Team"
}

# locals {
#   # Common tags to be assigned to all resources
#   common_tags = {
#     Service = local.service_name
#     Owner   = local.owner
#   }
# }

resource "aws_instance" "ubuntu" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  disable_api_termination     = true
  user_data                   = file("sayhello.sh")
  user_data_replace_on_change = true
  # associate_public_ip_address = true
  tags = {
    Name = var.instance_name
    Pet  = "${random_pet.name.id}"
  }
  # tags = local.common_tags
}

# output "vm_tags" {
#   value = type(local.common_tags)
# }
