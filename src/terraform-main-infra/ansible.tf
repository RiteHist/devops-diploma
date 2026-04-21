resource "local_file" "inventory_template" {
    content = templatefile("${path.module}/${var.ansible_inventory_path}/inventory.tftpl", {
        master_nodes = yandex_compute_instance.control[*]
        worker_nodes = yandex_compute_instance.worker[*]
    })
    filename = "${path.module}/${var.ansible_inventory_path}/inventory.ini"
}

resource "local_file" "group_vars" {
    content = templatefile("${path.module}/${var.ansible_inventory_path}/group_vars/all.tftpl", {
        username = var.vm_username
        nat = yandex_compute_instance.nat
    })
    filename = "${path.module}/${var.ansible_inventory_path}/group_vars/all.yaml"
}