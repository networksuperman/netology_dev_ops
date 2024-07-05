// Create SA
resource "yandex_iam_service_account" "netology1" {
    name      = "sa-for-ig"
}

// Grant permissions
resource "yandex_resourcemanager_folder_iam_member" "ig-editor" {
    folder_id = var.yandex_folder_id
    role      = "editor"
    member    = "serviceAccount:${yandex_iam_service_account.netology1.id}"
}

// Create instance group
resource "yandex_compute_instance_group" "ig-1" {
    name               = "fixed-ig-with-balancer"
    folder_id          = var.yandex_folder_id
    service_account_id = yandex_iam_service_account.netology1.id

    instance_template {
        resources {
            cores  = 2
            memory = 1
            core_fraction = 20
        }
        boot_disk {
            initialize_params {
                image_id = var.lamp-instance-image-id
            }
        }
        network_interface {
            network_id  = yandex_vpc_network.network-1.id
            subnet_ids  = [yandex_vpc_subnet.subnet-public.id]
            nat         = true
        }
        scheduling_policy {
            preemptible = true  // Прерываемая
        }
        metadata = {
            ssh-keys   = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
            user-data  = <<EOF
#!/bin/bash
apt install httpd -y
cd /var/www/html
echo '<html><img src="http://${yandex_storage_bucket.netology-bucket.bucket_domain_name}/netology.png"/></html>' > index.html
service httpd start
EOF
      }
   }

    scale_policy {
        fixed_scale {
            size = 3
        }
    }

    allocation_policy {
        zones = [var.a-zone]
    }

    deploy_policy {
        max_unavailable  = 1
        max_creating     = 3
        max_expansion    = 1
        max_deleting     = 1
        startup_duration = 3
    }

     health_check {
        http_options {
            port    = 80
            path    = "/"
        }
    }

    depends_on = [
        yandex_storage_bucket.netology-bucket
    ]

    load_balancer {
        target_group_name = "target-group"
    }
}
