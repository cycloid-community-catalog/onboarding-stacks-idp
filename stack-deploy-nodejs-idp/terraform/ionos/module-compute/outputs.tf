output "vm_public_ip" {
    value = ionoscloud_server.compute.primary_ip
}

output "vm_os_user" {
    value = var.ionos_username
}