module "vpc" {
  source    = "./vpc"
  env_name  = "develop"
  zone      = "ru-central1-a"
  cidr      = "10.0.1.0/24"
}

module "test-vm" {
  source          = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name        = "develop"
  network_id      = module.vpc.vpc_id
  subnet_zones    = ["ru-central1-a"]
  subnet_ids      = [ module.vpc.subnet_id ]
  instance_name   = "web"
  instance_count  = 2
  image_family    = "ubuntu-2004-lts"
  public_ip       = true
  
  metadata = {
      user-data          = data.template_file.cloudinit.rendered #Для демонстрации №3
      serial-port-enable = 1
  }

}

#Пример передачи cloud-config в ВМ для демонстрации №3

data "template_file" "cloudinit" {
 template = file("./cloud-init.yml")
 vars = {
   ssh_public_key = file("~/.ssh/id_rsa.pub")
}
}
