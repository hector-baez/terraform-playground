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


variable "vm_name" {
  description = "VM Name"
  type = string
}

variable "key_pair" {
  description = "Key pair name"
  type = string
}

variable "flavor_id" {
  description = "VM flavor: https://docs.jetstream-cloud.org/general/vmsizes/"
  type = number
}

variable "image_id" {
  description = "Openstack image ID"
  type = string
  default = "c86df12a-f99f-40cb-89d6-87f59d71e9f1"
}

variable "volume_size" {
  description = "Boot from volume size (GB)"
  type = number
  default = "100"
}

resource "openstack_networking_floatingip_v2" "float_ip" {
  pool = "public"
}

resource "openstack_compute_instance_v2" "server_instance" {
    name = "${var.vm_name}"
    image_name = var.image_id
    key_pair = var.key_pair
    flavor_id = var.flavor_id
    security_groups = [ "exosphere" ]

    block_device {
      uuid                  = var.image_id
      source_type           = "image"
      volume_size           = var.volume_size
      boot_index            = 0
      destination_type      = "volume"
      delete_on_termination = true
    }

    metadata = {
      terraform_controlled = "yes"
      ben_server = "/tmp/ben-qc"
    }
    network {
      name = "auto_allocated_network"
    }
}

resource "openstack_compute_floatingip_associate_v2" "server_instance_ip" {
  floating_ip = openstack_networking_floatingip_v2.float_ip.address
  instance_id = openstack_compute_instance_v2.server_instance.id
  wait_until_associated = true
}

output "public_ip" {
  value = openstack_networking_floatingip_v2.float_ip.address
  description = "The public IP address of the server"
}
