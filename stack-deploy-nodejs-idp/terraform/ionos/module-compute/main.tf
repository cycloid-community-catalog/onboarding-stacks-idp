resource "ionoscloud_server" "compute" {
  name              = "${var.cy_project}-${var.cy_env}-${var.cy_component}"
  datacenter_id     = ionoscloud_datacenter.datacenter.id
  availability_zone = "AUTO"
  type              = "CUBE"
  template_uuid     = data.ionoscloud_template.compute.id
  image_name        = "debian:latest"
  ssh_keys          = [tls_private_key.ssh_key.public_key_openssh]

  volume {
    name         = "Volume Cycloid Demo"
    licence_type = "LINUX" 
    disk_type    = "DAS"
  }
  
  nic {
    lan             = ionoscloud_lan.public.id
    name            = "Nic Cycloid"
    dhcp            = true
    firewall_active = false
  }
}

resource "ionoscloud_datacenter" "datacenter" {
  name     = "${var.cy_org}-${var.cy_project}-${var.cy_env}-${var.cy_component}"
  location = var.ionos_region
}

resource "ionoscloud_lan" "public" {
  datacenter_id = ionoscloud_datacenter.datacenter.id
  public        = true
}

data "ionoscloud_template" "compute" {
    name = var.ionos_cube
}