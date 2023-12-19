terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

resource "yandex_vpc_network" "vpc_net" {
  name = "${var.env_name}-network"
}
resource "yandex_vpc_subnet" "vpc_subnet" {
  for_each       = {for i in var.subnets: i.zone => i}
  name           = "${var.env_name}-${each.key}"
  zone           = each.value.zone
  network_id     = yandex_vpc_network.vpc_net.id
  v4_cidr_blocks = [each.value.cidr]
}