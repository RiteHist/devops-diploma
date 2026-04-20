data "template_file" "cloud_config" {
    template = file("${path.module}/cloud-init.tftpl")
    vars = {
        vm_username = var.vm_username
        ssh_pub_key = local.ssh_pub_key
    }
}

data "yandex_compute_image" "nat_image" {
    family = var.vm_params["nat_vm"].image_family
}

data "yandex_compute_image" "ubuntu_image" {
    family = var.vm_params["control_node"].image_family
}

resource "yandex_compute_instance" "nat_and_control" {
    for_each = { for k, v in var.vm_params : k => v if k != "worker_node" }

    name = each.value.name
    platform_id = each.value.platform_id

    resources {
        cores = each.value.cores
        memory = each.value.memory
        core_fraction = each.value.core_fraction
    }
    boot_disk {
        initialize_params {
            image_id = each.key == "nat_vm" ? data.yandex_compute_image.nat_image.image_id : data.yandex_compute_image.ubuntu_image.image_id
            size = each.value.disk_volume
        }
    }
    network_interface {
        nat = each.value.nat
        subnet_id = yandex_vpc_subnet.subnet["0"].id
        ip_address = lookup(each.value, "ip_address", null)
    }
    scheduling_policy {
        preemptible = each.value.preemptible
    }

    metadata = local.vm_metadata_combined
}

resource "yandex_compute_instance" "worker" {
    count = var.vm_params["worker_node"].replicas
    
    zone = var.zone_list[count.index]
    name = "${var.vm_params["worker_node"].name}-${count.index + 1}"
    platform_id = var.vm_params["worker_node"].platform_id

    resources {
        cores = var.vm_params["worker_node"].cores
        memory = var.vm_params["worker_node"].memory
        core_fraction = var.vm_params["worker_node"].core_fraction
    }
    boot_disk {
        initialize_params {
            image_id = data.yandex_compute_image.ubuntu_image.image_id
            size = var.vm_params["worker_node"].disk_volume
        }
    }
    network_interface {
        subnet_id = yandex_vpc_subnet.subnet["${count.index}"].id
        nat = var.vm_params["worker_node"].nat
    }
    scheduling_policy {
        preemptible = var.vm_params["worker_node"].preemptible
    }

    metadata = local.vm_metadata_combined
}