vm_username = "ritehist"

vm_params = {
    "nat_vm" = {
        name = "nat"
        image_family = "nat-instance-ubuntu-2204"
        cores = 2
        memory = 1
        core_fraction = 20
        preemptible = true
        platform_id = "standard-v4a"
        disk_volume = 10
        nat = true
        ip_address = "10.0.1.254"
    }
    "control_node" = {
        name = "control"
        image_family = "ubuntu-2204-lts"
        cores = 2
        memory = 8
        core_fraction = 100
        preemptible = true
        platform_id = "standard-v4a"
        disk_volume = 30
        nat = false
    }
    "worker_node" = {
        name = "worker"
        image_family = "ubuntu-2204-lts"
        cores = 2
        memory = 2
        core_fraction = 20
        preemptible = true
        platform_id = "standard-v4a"
        disk_volume = 10
        nat = false
        replicas = 3
    }
}

vm_metadata = {
    "serial-port-enable" = "1"
}