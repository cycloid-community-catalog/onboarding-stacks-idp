# Data source to find the Route53 hosted zone for cycloid-demo.com
data "aws_route53_zone" "zone" {
  name         = var.vm_aws_route53_zone
  private_zone = false
}

# Route53 wildcard A record for PR environments and argocd GUI (matches pr1.org-project-env.cycloid-demo.com and argocd.org-project-env.cycloid-demo.com)
resource "aws_route53_record" "cycloid-demo" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "*.${var.cy_org}-${var.cy_project}-${var.cy_env}.${var.vm_aws_route53_zone}"
  type    = "A"
  ttl     = 300
  records = [data.aws_instance.ec2.public_ip]
}