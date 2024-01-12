<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=0.13 |
| <a name="requirement_template"></a> [template](#requirement\_template) | ~> 2.0 |
| <a name="requirement_yandex"></a> [yandex](#requirement\_yandex) | >=0.99 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | 2.4.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.1 |
| <a name="provider_template"></a> [template](#provider\_template) | 2.2.0 |
| <a name="provider_yandex"></a> [yandex](#provider\_yandex) | 0.99.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_clickhouse"></a> [clickhouse](#module\_clickhouse) | git::https://github.com/udjin10/yandex_compute_instance.git | 95c286e0062805d5ba5edb866f387247bc1bbd44 |
| <a name="module_lighthouse"></a> [lighthouse](#module\_lighthouse) | git::https://github.com/udjin10/yandex_compute_instance.git | 95c286e0062805d5ba5edb866f387247bc1bbd44 |
| <a name="module_vector"></a> [vector](#module\_vector) | git::https://github.com/udjin10/yandex_compute_instance.git | 95c286e0062805d5ba5edb866f387247bc1bbd44 |
| <a name="module_vpc_dev"></a> [vpc\_dev](#module\_vpc\_dev) | ./vpc | n/a |
| <a name="module_vpc_prod"></a> [vpc\_prod](#module\_vpc\_prod) | ./vpc | n/a |

## Resources

| Name | Type |
|------|------|
| [local_file.ansible_inventory](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [null_resource.web_hosts_provision](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [yandex_vpc_security_group.example](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_security_group) | resource |
| [template_file.cloudinit_ansible](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.cloudinit_lighthouse](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.cloudinit_vector](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloud_id"></a> [cloud\_id](#input\_cloud\_id) | https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id | `string` | n/a | yes |
| <a name="input_default_zone"></a> [default\_zone](#input\_default\_zone) | https://cloud.yandex.ru/docs/overview/concepts/geo-scope | `string` | `"ru-central1-a"` | no |
| <a name="input_folder_id"></a> [folder\_id](#input\_folder\_id) | https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id | `string` | n/a | yes |
| <a name="input_security_group_egress"></a> [security\_group\_egress](#input\_security\_group\_egress) | secrules egress | <pre>list(object(<br>    {<br>      protocol       = string<br>      description    = string<br>      v4_cidr_blocks = list(string)<br>      port           = optional(number)<br>      from_port      = optional(number)<br>      to_port        = optional(number)<br>  }))</pre> | <pre>[<br>  {<br>    "description": "разрешить весь исходящий трафик",<br>    "from_port": 0,<br>    "protocol": "Any",<br>    "to_port": 65365,<br>    "v4_cidr_blocks": [<br>      "0.0.0.0/0"<br>    ]<br>  }<br>]</pre> | no |
| <a name="input_security_group_ingress"></a> [security\_group\_ingress](#input\_security\_group\_ingress) | secrules ingress | <pre>list(object(<br>    {<br>      protocol       = string<br>      description    = string<br>      v4_cidr_blocks = list(string)<br>      port           = optional(number)<br>      from_port      = optional(number)<br>      to_port        = optional(number)<br>  }))</pre> | <pre>[<br>  {<br>    "description": "разрешить входящий ssh",<br>    "port": 22,<br>    "protocol": "TCP",<br>    "v4_cidr_blocks": [<br>      "0.0.0.0/0"<br>    ]<br>  },<br>  {<br>    "description": "разрешить входящий  http",<br>    "port": 80,<br>    "protocol": "TCP",<br>    "v4_cidr_blocks": [<br>      "0.0.0.0/0"<br>    ]<br>  },<br>  {<br>    "description": "разрешить входящий https",<br>    "port": 443,<br>    "protocol": "TCP",<br>    "v4_cidr_blocks": [<br>      "0.0.0.0/0"<br>    ]<br>  },<br>  {<br>    "description": "разрешить входящий трафик для clickhouse",<br>    "port": 8123,<br>    "protocol": "Any",<br>    "v4_cidr_blocks": [<br>      "0.0.0.0/0"<br>    ]<br>  },<br>  {<br>    "description": "разрешить входящий трафик для lighthouse",<br>    "port": 8080,<br>    "protocol": "Any",<br>    "v4_cidr_blocks": [<br>      "0.0.0.0/0"<br>    ]<br>  }<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_external_ip_clickhouse"></a> [external\_ip\_clickhouse](#output\_external\_ip\_clickhouse) | network\_interface clickhouse |
| <a name="output_external_ip_lighthouse"></a> [external\_ip\_lighthouse](#output\_external\_ip\_lighthouse) | network\_interface lighthouse |
| <a name="output_external_ip_vector"></a> [external\_ip\_vector](#output\_external\_ip\_vector) | network\_interface vector |
<!-- END_TF_DOCS -->