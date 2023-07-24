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

variable "ben_server" {
  description = "Ben server socket file path"
  type = string
}