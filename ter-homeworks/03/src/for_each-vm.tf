resource "yandex_compute_instance""second_server" {
  for_each = {
    for key,value in var.vms:
    key => value
  }

  name        = each.value.vm_name
  platform_id = "standard-v1"
  resources {
    cores         = each.value.cpu
    memory        = each.value.ram
    core_fraction = each.value.core_fraction
  }


boot_disk {
  initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = each.value.disk_size
    }
}  

scheduling_policy {
  preemptible = true
  }
network_interface {
  subnet_id = yandex_vpc_subnet.develop.id
  nat       = true
}

metadata = local.ssh_keys_and_serial_port

 depends_on = [
    yandex_compute_instance.first_server
  ]

}
