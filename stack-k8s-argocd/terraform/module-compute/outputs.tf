output "vm_public_ip" {
  description = "The IP address the EC2 instance"
  value       = data.aws_instance.ec2.public_ip
}

output "vm_os_user" {
  description = "Admin username to connect to instance via SSH"
  value       = var.vm_os_user
}

output "instance_id" {
  value = data.aws_instance.ec2.id
}

output "dns_name" {
  description = "The DNS name for the application"
  value       = aws_route53_record.app.fqdn
}

output "url_dns" {
  description = "The URL of the application using DNS"
  value       = "http://${aws_route53_record.app.fqdn}"
}