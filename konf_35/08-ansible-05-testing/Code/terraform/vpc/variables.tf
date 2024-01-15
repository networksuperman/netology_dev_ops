variable "subnets" {
  type = list(object({ zone = string, cidr = list(string) }))
  # default     = [{ zone = "ru-central1-a", cidr = "10.0.1.0/24" }]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create and https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "env_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}
