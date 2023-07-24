output "public_ip" {
  value = openstack_networking_floatingip_v2.float_ip.address
  description = "The public IP address of the server"
}