//Create balancer
resource "yandex_lb_network_load_balancer" "load-balancer-1" {
  name = "network-load-balancer"

  listener {
    name = "lb-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_compute_instance_group.ig-1.load_balancer[0].target_group_id

    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/"
      }
    }
  }
  depends_on = [
    yandex_compute_instance_group.ig-1
]
}