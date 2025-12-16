output "vm_public_ip" {
  description = "The IP address the instance"
  value       = module.compute.vm_public_ip
}

output "vm_os_user" {
  description = "Admin username to connect to instance via SSH"
  value       = module.compute.vm_os_user
}

output "ssh" {
  description = "The SSH address to connect to the instance"
  value       = "${module.compute.vm_os_user}@${module.compute.vm_public_ip}"
}

output "url" {
  description = "The URL of the wepapp"
  value       = "http://${module.compute.vm_public_ip}"
}