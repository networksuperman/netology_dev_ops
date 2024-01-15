output "vpc_network_id" {
  value = yandex_vpc_network.network.id
}

output "vpc_network_name" {
  value = yandex_vpc_network.network.name
}

output "vpc_subnet_id" {
  value = values(yandex_vpc_subnet.subnet)[*].id
}

output "vpc_subnet_name" {
  value = yandex_vpc_subnet.subnet[*]
}

output "vpc_subnet_cidr" {
  value = yandex_vpc_subnet.subnet[*]
}

output "vpc_zone" {
  value = values(yandex_vpc_subnet.subnet)[*].zone
}
