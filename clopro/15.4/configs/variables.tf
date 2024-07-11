variable "token" {
  type = string
}

variable "cloud_id" {
  type = string
}

variable "folder_id" {
  type = string
}

variable "default_zone" {
  type    = string
  default = "ru-central1-a"
}
variable "a_zone" {
  type    = string
  default = "ru-central1-a"
}
variable "b_zone" {
  type    = string
  default = "ru-central1-b"
}
variable "c_zone" {
  type    = string
  default = "ru-central1-c"
}

variable "vm_platform_id" {
  type        = string
  default     = "standard-v1"
  description = "platform id"
}

variable "vm_resources" {
  type = map(any)
  default = {
    "cpu_cores"     = 2
    "memory"        = 2
    "core_fraction" = 5
  }
}

variable "nat-instance-address" {
  type        = string
  default     = "192.168.10.254"
  description = "nat ip"
}

variable "vm_image" {
  type        = string
  default     = "fd8ba0ukgkn46r0qr1gi"
  description = "image"
}

variable "vm_image_nat" {
  type        = string
  default     = "fd80mrhj8fl2oe87o4e1"
  description = "image nat"
}
variable "vm_image_lamp" {
  type        = string
  default     = "fd827b91d99psvq5fjit"
  description = "image lamp"
}

variable "nat-name" {
  type    = string
  default = "nat-vm"
}

variable "public-vm-name" {
  type    = string
  default = "public-vm-name"
}

variable "private-vm-name" {
  type    = string
  default = "private-vm-name"
}

variable "nat-ip" {
  type    = string
  default = "192.168.10.254"
}
