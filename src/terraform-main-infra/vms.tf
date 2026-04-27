data "template_file" "cloud_config" {
    template = file("${path.module}/cloud-init.tftpl")
    vars = {
        vm_username = var.vm_username
        ssh_pub_key = local.ssh_pub_key
        nat = false
        packages = null
        controller_ip = null
    }
}

data "template_file" "cloud_config_nat" {
    template = file("${path.module}/cloud-init.tftpl")
    vars = {
        vm_username = var.vm_username
        ssh_pub_key = local.ssh_pub_key
        nat = true
        packages = jsonencode(var.vm_params["nat_vm"].packages)
        controller_ip = yandex_compute_instance.control[0].network_interface[0].ip_address
    }
}

data "yandex_compute_image" "nat_image" {
    family = var.vm_params["nat_vm"].image_family
}

data "yandex_compute_image" "ubuntu_image" {
    family = var.vm_params["control_node"].image_family
}

resource "yandex_compute_instance" "nat" {
    name = var.vm_params["nat_vm"].name
    platform_id = var.vm_params["nat_vm"].platform_id

    resources {
        cores = var.vm_params["nat_vm"].cores
        memory = var.vm_params["nat_vm"].memory
        core_fraction = var.vm_params["nat_vm"].core_fraction
    }
    boot_disk {
        initialize_params {
            image_id = data.yandex_compute_image.nat_image.image_id
            size = var.vm_params["nat_vm"].disk_volume
        }
    }
    network_interface {
        nat = var.vm_params["nat_vm"].nat
        subnet_id = yandex_vpc_subnet.subnet["0"].id
        ip_address = var.vm_params["nat_vm"].ip_address
    }
    scheduling_policy {
        preemptible = var.vm_params["nat_vm"].preemptible
    }

    metadata = local.nat_metadata_combined
}

resource "yandex_compute_instance" "control" {
    count = var.vm_params["control_node"].replicas
    
    zone = count.index % 2 == 0 ? var.zone_list[1] : var.zone_list[2]
    name = "${var.vm_params["control_node"].name}-${count.index + 1}"
    platform_id = var.vm_params["control_node"].platform_id

    resources {
        cores = var.vm_params["control_node"].cores
        memory = var.vm_params["control_node"].memory
        core_fraction = var.vm_params["control_node"].core_fraction
    }
    boot_disk {
        initialize_params {
            image_id = data.yandex_compute_image.ubuntu_image.image_id
            size = var.vm_params["control_node"].disk_volume
        }
    }
    network_interface {
        subnet_id = count.index % 2 == 0 ? yandex_vpc_subnet.subnet["1"].id : yandex_vpc_subnet.subnet["2"].id
        nat = var.vm_params["control_node"].nat
    }
    scheduling_policy {
        preemptible = var.vm_params["control_node"].preemptible
    }

    metadata = local.vm_metadata_combined
}

resource "yandex_compute_instance" "worker" {
    count = var.vm_params["worker_node"].replicas
    
    zone = count.index % 2 == 0 ? var.zone_list[1] : var.zone_list[2]
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
        subnet_id = count.index % 2 == 0 ? yandex_vpc_subnet.subnet["1"].id : yandex_vpc_subnet.subnet["2"].id
        nat = var.vm_params["worker_node"].nat
    }
    scheduling_policy {
        preemptible = var.vm_params["worker_node"].preemptible
    }

    metadata = local.vm_metadata_combined
}