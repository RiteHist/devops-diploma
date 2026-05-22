variable "cloud_id" {
  type        = string
  description = "ID облака."
}
variable "folder_id" {
  type        = string
  description = "ID каталога в облаке."
}

variable "vpc_name" {
  type        = string
  default     = "idunno"
  description = "Название VPC."
}

variable "zone_list" {
  type        = list(string)
  default     = ["ru-central1-a", "ru-central1-b", "ru-central1-d"]
  description = "Список зон доступности."
}

variable "subnet_cidr_list" {
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  description = "Список CIDR."
}

variable "vm_username" {
  type        = string
  description = "Имя пользователя VM."
}

variable "ssh_key_paths" {
  type        = list(string)
  default     = ["~/.ssh/id_ed25519.pub"]
  description = "Список путей к файлам публичной части SSH ключа."
}

variable "vm_metadata" {
  type        = map(string)
  description = "Метаданные VM."
}

variable "vm_params" {
  type = map(object({
    name          = string
    image_family  = string
    platform_id   = string
    cores         = number
    memory        = number
    core_fraction = number
    preemptible   = bool
    nat           = bool
    disk_volume   = number
    ip_address    = optional(string)
    replicas      = optional(number)
    packages      = optional(list(string))
    labels        = optional(map(string))
  }))
  description = "Параметры VM."
}

variable "ansible_inventory_path" {
  type        = string
  description = "Путь, где находится каталог inventory для ansible."
}