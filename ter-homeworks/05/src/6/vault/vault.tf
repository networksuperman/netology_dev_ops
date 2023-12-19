provider "vault" {
 address = "http://127.0.0.1:8200"
 skip_tls_verify = true
 token = "education"
}

data "vault_generic_secret" "vault_example"{
 path = "secret/example"
}

resource "vault_generic_secret" "top_secret" {
  path = "secret/example"

  data_json = jsonencode({
    top_secret = var.my_secret
  })
}

variable "my_secret" {
  type    = string
  default = "Swordfish"
}

output "vault_example" {
 value = "${nonsensitive(data.vault_generic_secret.vault_example.data)}"
}