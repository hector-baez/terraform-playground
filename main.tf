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


resource "openstack_compute_instance_v2" "test-server" {
    name = "test-server"
    image_name = "Featured-Ubuntu22"
    flavor_id = "1"
}