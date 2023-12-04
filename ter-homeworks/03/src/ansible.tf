resource "local_file" "hosts_cfg" {
  content = templatefile("${path.module}/hosts.tftpl",
    {
      webservers = yandex_compute_instance.second_server
      databases  = yandex_compute_instance.first_server
      storage    = [yandex_compute_instance.storage_server]
    }
  )
  filename = "${abspath(path.module)}/hosts.cfg"
}
