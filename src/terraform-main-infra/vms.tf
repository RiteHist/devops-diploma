data "template_file" "cloud-config" {
    template = file("${path.module}/cloud-init.tftpl")
    vars = {
        vm_username = var.vm_username
        ssh_pub_key = local.ssh_pub_key
    }
}