output "vm_public_ip" {
  description = "The IP address the EC2 instance"
  value       = module.compute.vm_public_ip
}

output "ssh" {
  description = "The SSH address to connect to the instance"
  value       = "${module.compute.vm_os_user}@${module.compute.vm_public_ip}"
}

output "url" {
  description = "The URL of the wepapp"
  value       = "http://${module.compute.vm_public_ip}"
}

output "instance_id" {
  value = module.compute.instance_id
}

output "dns_name" {
  description = "The DNS name for the application"
  value       = module.compute.dns_name
}

output "url_dns" {
  description = "The URL of the application using DNS"
  value       = module.compute.url_dns
}