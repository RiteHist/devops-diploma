resource "yandex_vpc_network" "vpc" {
    name = var.vpc_name
}

resource "yandex_vpc_subnet" "subnet" {
    for_each = local.subnets
    name = "${var.vpc_name}-subnet-${each.key + 1}"
    zone = each.value.zone
    v4_cidr_blocks = [each.value.cidr]
    network_id = yandex_vpc_network.vpc.id
    route_table_id = yandex_vpc_route_table.rt_nat.id
}