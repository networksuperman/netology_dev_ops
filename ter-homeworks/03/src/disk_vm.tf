resource "yandex_compute_disk" "default_disk" {
  count      = 3
  name       = "default-disk-${count.index + 1}"
  type       = "network-hdd"
  zone       = var.default_zone
  size       = 1
  block_size = 4096
}

resource "yandex_compute_instance" "storage_server" {

    depends_on = [yandex_compute_disk.default_disk]

  name        = "storage"
  platform_id = "standard-v1"

  resources {
    cores         = var.vm_resources.cores
    memory        = var.vm_resources.memory
    core_fraction = var.vm_resources.core_fraction
  }

boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }

  dynamic "secondary_disk" {
    for_each = toset(yandex_compute_disk.default_disk[*].id)
    content {
      disk_id     = secondary_disk.key
      auto_delete = true
    }
  }

metadata = local.ssh_keys_and_serial_port

scheduling_policy {
    preemptible = true
  }

   network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

 allow_stopping_for_update = true

}
