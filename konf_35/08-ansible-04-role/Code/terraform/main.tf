module "vpc_dev" {
  source   = "./vpc"
  env_name = "develop"
  subnets = [
    { zone = "ru-central1-a", cidr = ["10.0.1.0/24"] },
  ]
}

module "vpc_prod" {
  source   = "./vpc"
  env_name = "production"
  subnets = [
    { zone = "ru-central1-a", cidr = ["10.0.1.0/24"] },
    { zone = "ru-central1-b", cidr = ["10.0.2.0/24"] },
    { zone = "ru-central1-c", cidr = ["10.0.3.0/24"] },
  ]
}


module "clickhouse" {
  source             = "git::https://github.com/P0zitiff4ik/yandex_compute_instance.git?ref=6824c8ad867d46ceece5c3e970828399dde72903"
  env_name           = "develop"
  network_id         = module.vpc_dev.vpc_network_id
  subnet_zones       = [module.vpc_dev.vpc_zone[0]]
  subnet_ids         = [module.vpc_dev.vpc_subnet_id[0]]
  instance_name      = "clickhouse"
  instance_count     = 1
  image_family       = "centos-7"
  public_ip          = true
  security_group_ids = [yandex_vpc_security_group.example.id]
  metadata = {
    user-data          = templatefile("${path.module}/cloud-init/clickhouse.yml", { ssh_public_key = file("~/.ssh/id_ed25519.pub") })
    serial-port-enable = 1
  }
}

module "vector" {
  source             = "git::https://github.com/P0zitiff4ik/yandex_compute_instance.git?ref=6824c8ad867d46ceece5c3e970828399dde72903"
  env_name           = "develop"
  network_id         = module.vpc_dev.vpc_network_id
  subnet_zones       = [module.vpc_dev.vpc_zone[0]]
  subnet_ids         = [module.vpc_dev.vpc_subnet_id[0]]
  instance_name      = "vector"
  instance_count     = 1
  image_family       = "centos-7"
  public_ip          = true
  security_group_ids = [yandex_vpc_security_group.example.id]
  metadata = {
    user-data          = templatefile("${path.module}/cloud-init/vector.yml", { ssh_public_key = file("~/.ssh/id_ed25519.pub") })
    serial-port-enable = 1
  }
}

module "lighthouse" {
  source             = "git::https://github.com/P0zitiff4ik/yandex_compute_instance.git?ref=6824c8ad867d46ceece5c3e970828399dde72903"
  env_name           = "develop"
  network_id         = module.vpc_dev.vpc_network_id
  subnet_zones       = [module.vpc_dev.vpc_zone[0]]
  subnet_ids         = [module.vpc_dev.vpc_subnet_id[0]]
  instance_name      = "lighthouse"
  instance_count     = 1
  image_family       = "centos-7"
  public_ip          = true
  security_group_ids = [yandex_vpc_security_group.example.id]
  metadata = {
    user-data          = templatefile("${path.module}/cloud-init/lighthouse.yml", { ssh_public_key = file("~/.ssh/id_ed25519.pub") })
    serial-port-enable = 1
  }
}
