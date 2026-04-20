resource "yandex_vpc_route_table" "rt_nat" {
    network_id = yandex_vpc_network.vpc.id

    static_route {
        destination_prefix = "0.0.0.0/0"
        next_hop_address = var.vm_params["nat_vm"].ip_address
    }
}