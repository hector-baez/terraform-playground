# Define required providers
terraform {
required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.51.1"
    }
  }
}


provider "openstack" {}

module "js2_server" {
  source = "./modules/services/js2-server"

  vm_name = "test-server"
  key_pair = "hbaez-private-key"
  flavor_id = 1
  # image_id
  volume_size = 100
  ben_server = "/tmp/ben-qc"
}