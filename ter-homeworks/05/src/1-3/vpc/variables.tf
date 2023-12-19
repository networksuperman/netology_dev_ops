variable "env_name" {
  type    = string
  description = "Имя облачной сети"
}

variable "zone" {
  type    = string
  description = "Зона, в которой создать подсеть"
}

variable "cidr" {
  type    = string
  description = "CIDR-блок для подсети"
}

