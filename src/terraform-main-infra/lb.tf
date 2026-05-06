resource "yandex_lb_target_group" "k8s_tg" {
    name = "k8s-tg"
    dynamic "target" {
        for_each = yandex_compute_instance.worker[*]
        content {
            subnet_id = target.value.network_interface[0].subnet_id
            address = target.value.network_interface[0].ip_address
        }
    }
}

resource "yandex_lb_network_load_balancer" "nlb" {
    name = "k8s-nlb"

    listener {
        name = "k8s-listener"
        port = 80
        external_address_spec {
            ip_version = "ipv4"
        }
    }

    attached_target_group {
        target_group_id = yandex_lb_target_group.k8s_tg.id

        healthcheck {
            name = "http"
            http_options {
                port = 80
                path = "/"
            }
        }
    }
}