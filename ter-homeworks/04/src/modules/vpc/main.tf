terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

#создаем облачную сеть
resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}

#создаем подсеть
resource "yandex_vpc_subnet" "develop" {
  count = length(var.v4_cidr_blocks)
  name           = "${var.subnet_name}-${var.v4_cidr_blocks[count.index].zone}"
  zone           = var.v4_cidr_blocks[count.index].zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.v4_cidr_blocks[count.index].cidr
}
