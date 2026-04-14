variable "cloud_id" {
    type = string
}

variable "folder_id" {
    type = string
}

variable "zone" {
    type = string
    default = "ru-central1-a"
}

variable "bucket_params" {
    type = object({
        prefix = string
        max_size = number
    })
    default = {
        prefix = "tfstate"
        max_size = 1024
    }
}

variable "sa_name" {
    type = string
    default = "terraform-state"
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
        table_path = "tfstate"
        table_column_name = "LockID"
        table_column_type = "Utf8"
    }
}