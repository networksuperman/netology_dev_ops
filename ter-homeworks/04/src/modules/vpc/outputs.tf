output "network_id" {
  value = yandex_vpc_network.develop.id
}

output "subnet_id" {
  value = yandex_vpc_subnet.develop.*.id
}

output "subnet_zones" {
  value = yandex_vpc_subnet.develop.*.zone
}
