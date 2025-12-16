# Data source to find the Route53 hosted zone for cycloid-demo.com
data "aws_route53_zone" "cycloid_demo" {
  name         = "cycloid-demo.com"
  private_zone = false
}

# Route53 wildcard A record for PR environments and argocd GUI (matches pr1.org-project-env.cycloid-demo.com and argocd.org-project-env.cycloid-demo.com)
resource "aws_route53_record" "cycloid-demo" {
  zone_id = data.aws_route53_zone.cycloid_demo.zone_id
  name    = "*.${var.cy_org}-${var.cy_project}-${var.cy_env}.cycloid-demo.com"
  type    = "A"
  ttl     = 300
  records = [module.compute.vm_public_ip]
}

# Route53 wildcard A record for PR environments and argocd GUI (matches pr1.org-project-env.cycloid-demo.com and argocd.org-project-env.cycloid-demo.com)
resource "aws_route53_record" "demo-cycloid" {
  zone_id = data.aws_route53_zone.cycloid_demo.zone_id
  name    = "*.${var.cy_org}-${var.cy_project}-${var.cy_env}.demo.cycloid.io"
  type    = "A"
  ttl     = 300
  records = [module.compute.vm_public_ip]
}