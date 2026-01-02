resource "outscale_vm" "compute" {
    image_id                 = data.outscale_images.debian.images[0].image_id
    vm_type                  = "tinav${var.outscale_cpu_gen}.c${var.outscale_cpu}r${var.outscale_mem}p1"
    keypair_name             = outscale_keypair.cycloid_keypair.keypair_name
    security_group_ids       = [outscale_security_group.security_group01.security_group_id]
    placement_subregion_name = var.outscale_region
    placement_tenancy        = "default"
    tags {
        key   = "name"
        value = "${var.cy_org}-${var.cy_project}-${var.cy_env}-${var.cy_component}"
    }
}

resource "outscale_security_group" "security_group01" {
  description         = "vm security group"
  security_group_name = "${var.cy_org}-${var.cy_project}-${var.cy_env}-${var.cy_component}"
}

resource "outscale_security_group_rule" "ssh" {
    flow              = "Inbound"
    security_group_id = outscale_security_group.security_group01.security_group_id
    from_port_range   = "22"
    to_port_range     = "22"
    ip_protocol       = "tcp"
    ip_range          = "0.0.0.0/0"
    # ip_range          = "${chomp(data.http.worker_ip.response_body)}/32"
}

resource "outscale_security_group_rule" "http" {
    flow              = "Inbound"
    security_group_id = outscale_security_group.security_group01.security_group_id
    from_port_range   = "80"
    to_port_range     = "80"
    ip_protocol       = "tcp"
    ip_range          = "0.0.0.0/0"
    # ip_range          = "${chomp(data.http.worker_ip.response_body)}/32"
}

resource "outscale_security_group_rule" "https" {
    flow              = "Inbound"
    security_group_id = outscale_security_group.security_group01.security_group_id
    from_port_range   = "443"
    to_port_range     = "443"
    ip_protocol       = "tcp"
    ip_range          = "0.0.0.0/0"
    # ip_range          = "${chomp(data.http.worker_ip.response_body)}/32"
}

resource "outscale_security_group_rule" "3000" {
    flow              = "Inbound"
    security_group_id = outscale_security_group.security_group01.security_group_id
    from_port_range   = "3000"
    to_port_range     = "3000"
    ip_protocol       = "tcp"
    ip_range          = "0.0.0.0/0"
    # ip_range          = "${chomp(data.http.worker_ip.response_body)}/32"
}

resource "outscale_security_group_rule" "8080" {
    flow              = "Inbound"
    security_group_id = outscale_security_group.security_group01.security_group_id
    from_port_range   = "8080"
    to_port_range     = "8080"
    ip_protocol       = "tcp"
    ip_range          = "0.0.0.0/0"
    # ip_range          = "${chomp(data.http.worker_ip.response_body)}/32"
}


resource "outscale_security_group_rule" "http" {
    flow              = "Inbound"
    security_group_id = outscale_security_group.security_group01.security_group_id
    from_port_range   = "80"
    to_port_range     = "80"
    ip_protocol       = "tcp"
    ip_range          = "0.0.0.0/0"
}

resource "outscale_security_group_rule" "https" {
    flow              = "Inbound"
    security_group_id = outscale_security_group.security_group01.security_group_id
    from_port_range   = "443"
    to_port_range     = "443"
    ip_protocol       = "tcp"
    ip_range          = "0.0.0.0/0"
}

resource "outscale_security_group_rule" "k8s" {
    flow              = "Inbound"
    security_group_id = outscale_security_group.security_group01.security_group_id
    from_port_range   = "6443"
    to_port_range     = "6443"
    ip_protocol       = "tcp"
    ip_range          = "0.0.0.0/0"
}

data "outscale_images" "debian" {
    filter {
        name   = "account_aliases"
        values = ["Outscale"]
    }
    filter {
        name   = "image_names"
        values = ["Debian-12*"]
    }
}