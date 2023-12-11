variable "cidr" {
  type        = string
  default     = "10.0.0.0/24"
}

variable "zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}

variable "env_name" {
  type        = string
  default     = "develop"
  description = "Environment name"
}
