variable "vm_web_name" {
  type        = string
  default     = "netology-develop-platform-web"
  description = "VM name"
}

variable "vm_web_platform_id" {
  type        = string
  default     = "standard-v1"
  description = "platform id"
}

variable "vm_web_is_nat" {
  type        = bool
  default     = true
  description = "is nat is necessary"
}

variable "vm_web_is_preemptible" {
  type        = bool
  default     = true
  description = "is preemptible"
}

variable "vm_web_resources" {
  type = map(any)
  default = {
    "cpu_cores"    = 2
    "cpu_fraction" = 5
    "memory"       = 1
  }
}

variable "vm_db_resources" {
  type = map(any)
  default = {
    "cpu_cores"    = 2
    "cpu_fraction" = 20
    "memory"       = 2
  }
}

variable "metadata" {
  type = map(any)
  default = {
    "serial-port-enable" = 1
    "ssh-keys"           = "your_public_key"
  }
}

variable "vm_db_name" {
  type        = string
  default     = "netology-develop-platform-db"
  description = "VM name"
}

variable "vm_db_platform_id" {
  type        = string
  default     = "standard-v1"
  description = "platform id"
}

variable "vm_db_is_nat" {
  type        = bool
  default     = true
  description = "is nat is necessary"
}

variable "vm_db_is_preemptible" {
  type        = bool
  default     = true
  description = "is preemptible"
}
