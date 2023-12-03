locals {
  platform_name = "${var.vm_web_name}-${var.vm_web_platform_id}"
  db_name       = "${var.vm_db_name}-${var.vm_db_platform_id}"
}
