variable "subnet_zones" {
  type = string
  default = "ru-central1-a"
}

variable "subnet_name" {
  type = string
  default = "default-subnet-name"
}

variable "vpc_name" {
  type = string
  default = "develop"
}

variable "v4_cidr_blocks" {
  type = list(object({zone = string, cidr = list(string)}))
  default = [ { zone = "ru-central1-a", cidr = ["10.0.1.0/24"] } ]
}
