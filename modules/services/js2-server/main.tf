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

locals {
  security_group = "exosphere"
  network = "auto_allocated_network"
}

resource "openstack_networking_floatingip_v2" "float_ip" {
  pool = "public"
}

resource "openstack_compute_instance_v2" "server_instance" {
    name = "${var.vm_name}"
    image_name = var.image_id
    key_pair = var.key_pair
    flavor_id = var.flavor_id
    security_groups = [ local.security_group ]

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
      ben_server = var.ben_server
    }
    network {
      name = local.network
    }
}

resource "openstack_compute_floatingip_associate_v2" "server_instance_ip" {
  floating_ip = openstack_networking_floatingip_v2.float_ip.address
  instance_id = openstack_compute_instance_v2.server_instance.id
  wait_until_associated = true
}
