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

resource "yandex_compute_instance" "nat_vm" {
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
        subnet_id = yandex_vpc_subnet.subnet["0"].id
        nat = var.vm_params["nat_vm"].nat
        ip_address = var.vm_params["nat_vm"].ip_address
    }
    scheduling_policy {
        preemptible = var.vm_params["nat_vm"].preemptible
    }
    metadata = local.vm_metadata_combined
}