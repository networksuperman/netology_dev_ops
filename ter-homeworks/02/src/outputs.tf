output "external_ip" {
  value = (tomap(
    { "${yandex_compute_instance.platform.name}" = "${yandex_compute_instance.platform.network_interface[0].nat_ip_address}"
    "${yandex_compute_instance.db.name}" = "${yandex_compute_instance.db.network_interface[0].nat_ip_address}" }
  ))
}
