module "vpc" {
  source       = "./modules/vpc"
  subnet_zones = "ru-central1-b"
  subnet_name  = "develop-ru-central1-b"
  v4_cidr_blocks = [{ zone = "ru-central1-a", cidr = ["10.0.1.0/24"] }, { zone = "ru-central1-b", cidr = ["10.0.2.0/24"] },
  { zone = "ru-central1-c", cidr = ["10.0.3.0/24"] }]
  vpc_name = "develop"
}

module "test-vm" {
  source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name       = "develop"
  network_id     = module.vpc.network_id
  subnet_zones   = module.vpc.subnet_zones
  subnet_ids     = module.vpc.subnet_id
  instance_name  = "web"
  instance_count = 2
  image_family   = "ubuntu-2004-lts"
  public_ip      = true

  metadata = {
    user-data          = data.template_file.cloudinit.rendered #Для демонстрации №3
    serial-port-enable = 1
  }

}

#Пример передачи cloud-config в ВМ для демонстрации №3
data "template_file" "cloudinit" {
  template = file("./cloud-init.yml")

  vars = {
    ssh = file(var.vms_ssh_key)
  }
}
