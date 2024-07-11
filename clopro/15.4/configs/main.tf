#resource "yandex_compute_instance" "nat-instance" {
#  name        = var.nat-name
#  platform_id = var.vm_platform_id
#  zone        = var.default_zone
#
#  resources {
#    cores         = var.vm_resources.cpu_cores
#    memory        = var.vm_resources.memory
#    core_fraction = var.vm_resources.core_fraction
#  }
#
#  boot_disk {
#    initialize_params {
#      image_id = var.vm_image_nat
#    }
#  }
#
#  network_interface {
#    subnet_id  = yandex_vpc_subnet.public-subnet.id
#    ip_address = var.nat-instance-address
#    nat        = true
#  }
#
#  metadata = {
#    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
#  }
#}

#resource "yandex_compute_instance" "public-instance" {
#  name        = var.public-vm-name
#  platform_id = var.vm_platform_id
#  zone        = var.default_zone
#
#  resources {
#    cores         = var.vm_resources.cpu_cores
#    memory        = var.vm_resources.memory
#    core_fraction = var.vm_resources.core_fraction
#  }
#
#  boot_disk {
#    initialize_params {
#      image_id = var.vm_image
#    }
#  }
#
#  network_interface {
#    subnet_id = yandex_vpc_subnet.public-subnet.id
#    nat       = true
#  }
#
#  metadata = {
#    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
#  }
#}

#resource "yandex_compute_instance" "private-instance" {
#  name        = var.private-vm-name
#  platform_id = var.vm_platform_id
#  zone        = var.default_zone
#
#  resources {
#    cores         = var.vm_resources.cpu_cores
#    memory        = var.vm_resources.memory
#    core_fraction = var.vm_resources.core_fraction
#  }
#
#  boot_disk {
#    initialize_params {
#      image_id = var.vm_image
#    }
#  }
#
#  network_interface {
#    subnet_id = yandex_vpc_subnet.private-subnet.id
#  }
#
#  metadata = {
#    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
#  }
#}
