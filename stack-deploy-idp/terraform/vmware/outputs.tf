output "vm_public_ip" {
  description = "The IP address the instance"
  value       = module.compute.vm_public_ip
}

output "vm_os_user" {
  description = "Admin username to connect to instance via SSH"
  value       = module.compute.vm_os_user
}