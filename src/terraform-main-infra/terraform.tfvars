vm_username = "ritehist"

vm_params = {
    "nat_vm" = {
        name = "nat_vm"
        image_family = "nat-instance-ubuntu-2204"
        cores = 2
        memory = 1
        core_fraction = 20
        preemptible = true
        platform_id = "standard-v4a"
        disk_volume = 10
        nat = true
        ip_address = "10.0.1.255"
    }
}

vm_metadata = {
    "serial-port-enable" = "1"
}