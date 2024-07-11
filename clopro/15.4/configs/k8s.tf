resource "yandex_kubernetes_cluster" "my-cluster" {
  name        = "my-cluster"
  description = "regional cluster k8s netology"

  network_id = yandex_vpc_network.devops_net.id


  master {

    regional {
      region = "ru-central1"

      location {
        zone      = yandex_vpc_subnet.public-subnet-a.zone
        subnet_id = yandex_vpc_subnet.public-subnet-a.id
      }

      location {
        zone      = yandex_vpc_subnet.public-subnet-b.zone
        subnet_id = yandex_vpc_subnet.public-subnet-b.id
      }

      location {
        zone      = yandex_vpc_subnet.public-subnet-c.zone
        subnet_id = yandex_vpc_subnet.public-subnet-c.id
      }
    }

    version   = 1.28
    public_ip = true

  }

  service_account_id      = yandex_iam_service_account.sa-k8s.id
  node_service_account_id = yandex_iam_service_account.sa-k8s.id

  kms_provider {
    key_id = yandex_kms_symmetric_key.key-a.id
  }


  depends_on = [
    yandex_resourcemanager_folder_iam_member.k8s-clusters-agent,
    yandex_resourcemanager_folder_iam_member.vpc-public-admin,
    yandex_resourcemanager_folder_iam_member.images-puller,
    yandex_resourcemanager_folder_iam_member.editor,
    yandex_resourcemanager_folder_iam_member.encrypterDecrypter
  ]

}

resource "yandex_kubernetes_node_group" "my-node-group" {
  cluster_id  = yandex_kubernetes_cluster.my-cluster.id
  name        = "my-node-group"
  description = "description"
  version     = "1.28"

  instance_template {
    platform_id = "standard-v1"

    network_interface {
      nat = true
      subnet_ids = [
        "${yandex_vpc_subnet.public-subnet-a.id}"
      ]
    }

    resources {
      memory        = var.vm_resources.memory
      cores         = var.vm_resources.cpu_cores
      core_fraction = var.vm_resources.core_fraction
    }

    boot_disk {
      type = "network-ssd"
      size = 30
    }

    scheduling_policy {
      preemptible = true
    }

    container_runtime {
      type = "containerd"
    }
  }

  scale_policy {
    auto_scale {
      min     = 3
      initial = 3
      max     = 6
    }
  }

  allocation_policy {
    location {
      zone = var.a_zone
    }

  }
}
