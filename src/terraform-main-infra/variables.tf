variable "cloud_id" {
    type = string
}

variable "folder_id" {
    type = string
}

variable "vpc_name" {
    type = string
    default = "idunno"
}

variable "zone_list" {
    type = list(string)
    default = ["ru-central1-a", "ru-central1-b", "ru-central1-d"]
}

variable "subnet_cidr_list" {
    type = list(string)
    default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "vm_username" {
    type = string
}

variable "ssh_key_path" {
    type = string
    default = "~/.ssh/id_ed25519.pub"
}

variable "vm_metadata" {
    type = map(string)
}

variable "vm_params" {
    type = map(object({
        name = string
        image_family = string
        platform_id = string
        cores = number
        memory = number
        core_fraction = number
        preemptible = bool
        nat = bool
        disk_volume = number
        ip_address = optional(string)
        replicas = optional(number)
    }))
}