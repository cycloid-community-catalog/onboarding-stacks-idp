output "vm_public_ip" {
    value = outscale_vm.compute.public_ip
}

output "vm_os_user" {
    value = var.outscale_username
}