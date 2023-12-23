
data "template_file" "cloudinit_ansible" {
  template = file("./cloud-init/ansible.yml")

  vars = {
    ssh_public_key = file("~/.ssh/id_ed25519.pub")
  }
}

data "template_file" "cloudinit_vector" {
  template = file("./cloud-init/vector.yml")

  vars = {
    ssh_public_key = file("~/.ssh/id_ed25519.pub")
  }
}

data "template_file" "cloudinit_lighthouse" {
  template = file("./cloud-init/lighthouse.yml")

  vars = {
    ssh_public_key = file("~/.ssh/id_ed25519.pub")
  }
}

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
  source             = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=95c286e0062805d5ba5edb866f387247bc1bbd44"
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
    user-data          = data.template_file.cloudinit_ansible.rendered
    serial-port-enable = 1
  }
}

module "vector" {
  source             = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=95c286e0062805d5ba5edb866f387247bc1bbd44"
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
    user-data          = data.template_file.cloudinit_vector.rendered
    serial-port-enable = 1
  }
}

module "lighthouse" {
  source             = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=95c286e0062805d5ba5edb866f387247bc1bbd44"
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
    user-data          = data.template_file.cloudinit_lighthouse.rendered
    serial-port-enable = 1
  }
}