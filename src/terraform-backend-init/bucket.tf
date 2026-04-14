resource "yandex_storage_bucket" "backend_bucket" {
    bucket_prefix = var.bucket_params.prefix
    max_size = var.bucket_params.max_size
    folder_id = var.folder_id
}