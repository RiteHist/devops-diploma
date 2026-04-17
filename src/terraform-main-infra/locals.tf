locals {
    subnets = {
        for i, zone in var.zone_list : i => {
            zone = zone
            cidr = var.subnet_cidr_list[i]
        }
    }
    ssh_pub_key = file(var.ssh_key_path)
}