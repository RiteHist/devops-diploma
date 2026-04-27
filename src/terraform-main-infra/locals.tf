locals {
    subnets = {
        for i, zone in var.zone_list : i => {
            zone = zone
            cidr = var.subnet_cidr_list[i]
        }
    }
    ssh_pub_key = file(var.ssh_key_path)
    vm_metadata_combined = merge(var.vm_metadata, {"user-data" = "${data.template_file.cloud_config.rendered}"})
    nat_metadata_combined = merge(var.vm_metadata, {"user-data" = "${data.template_file.cloud_config_nat.rendered}"})
}