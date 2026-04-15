variable "cloud_id" {
    type = string
    description = "ID облака"
}

variable "folder_id" {
    type = string
    description = "ID каталога в облаке"
}

variable "zone" {
    type = string
    default = "ru-central1-a"
    description = "Дефолтная зона доступности"
}

variable "bucket_params" {
    type = object({
        prefix = string
        max_size = number
        force_destroy = bool
    })
    default = {
        prefix = "tfstate"
        max_size = 10485760
        force_destroy = true
    }
    description = "Параметры s3 бакета"
}

variable "sa_names" {
    type = list(string)
    default = ["terraform-state", "terraform-admin"]
    description = "Список имен сервисных аккаунтов"
}

variable "roles" {
    type = list(string)
    default = ["storage.editor", "ydb.editor", "admin"]
    description = "Список ролей для сервисных аккаунтов"
}

variable "ydb_params" {
    type = object({
      name = string
      deletion_protection = bool
      storage_size_limit = number
      enable_throttling_rcu_limit = bool
      provisioned_rcu_limit = number
      throttling_rcu_limit = number
      table_path = string
      table_column_name = string
      table_column_type = string
    })
    default = {
        name = "terraform-lock"
        deletion_protection = false
        storage_size_limit = 1
        enable_throttling_rcu_limit = true
        provisioned_rcu_limit = 0
        throttling_rcu_limit = 10
        table_path = "tflock"
        table_column_name = "LockID"
        table_column_type = "S"
    }
    description = "Параметры YDB и создаваемой таблицы"
}

variable "dest_folder" {
    type = string
    default = "../terraform-main-infra"
    description = "Относительный путь до каталога, где должны создаться файлы конфигурации бэкэнда"
}