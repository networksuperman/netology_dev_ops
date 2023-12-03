# resource "yandex_vpc_network" "develop" {
#   name = var.vpc_name
# }
# resource "yandex_vpc_subnet" "develop" {
#   name           = var.vpc_name
#   zone           = var.default_zone
#   network_id     = yandex_vpc_network.develop.id
#   v4_cidr_blocks = var.default_cidr
# }


data "yandex_compute_image" "ubuntu" {
  family = var.os_family
}

data "yandex_vpc_subnet" "default" {
  name = "default-ru-central1-a"
}

resource "yandex_compute_instance" "platform" {
  name        = local.platform_name
  platform_id = var.vm_web_platform_id
  resources {
    cores         = var.vm_web_resources.cpu_cores
    memory        = var.vm_web_resources.memory
    core_fraction = var.vm_web_resources.cpu_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = var.vm_web_is_preemptible
  }
  network_interface {
    subnet_id = data.yandex_vpc_subnet.default.id
    nat       = var.vm_web_is_nat
  }

  metadata = {
    serial-port-enable = var.metadata.serial-port-enable
    ssh-keys           = "ubuntu:${var.metadata.ssh-keys}"
  }

}

resource "yandex_compute_instance" "db" {
  name        = local.db_name
  platform_id = var.vm_db_platform_id
  resources {
    cores         = var.vm_db_resources.cpu_cores
    memory        = var.vm_db_resources.memory
    core_fraction = var.vm_db_resources.cpu_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = var.vm_db_is_preemptible
  }
  network_interface {
    subnet_id = data.yandex_vpc_subnet.default.id
    nat       = var.vm_db_is_nat
  }

  metadata = {
    serial-port-enable = var.metadata.serial-port-enable
    ssh-keys           = "ubuntu:${var.metadata.ssh-keys}"
  }

}
