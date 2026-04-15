resource "local_file" "backend" {
    content = templatefile("${path.module}/backend.tftpl", {
        dynamodb = yandex_ydb_database_serverless.tflock_db.document_api_endpoint
        bucket = yandex_storage_bucket.backend_bucket.id
        dynamodb_table = module.tflock_table.table_name
    })
    filename = "${path.module}/${var.dest_folder}/backend.hcl"
}

resource "local_file" "tfinit" {
    content = templatefile("${path.module}/tfinit.tftpl", {
        access_key = yandex_iam_service_account_static_access_key.tf_sa_key.access_key
        secret_key = yandex_iam_service_account_static_access_key.tf_sa_key.secret_key
    })
    filename = "${path.module}/${var.dest_folder}/tfinit.sh"
}

resource "local_file" "authorized_key" {
    content = jsonencode({
        id = yandex_iam_service_account_key.admin_sa_key.id
        service_account_id = yandex_iam_service_account.admin_sa.id
        created_at = yandex_iam_service_account_key.admin_sa_key.created_at
        key_algorithm = yandex_iam_service_account_key.admin_sa_key.key_algorithm
        public_key = yandex_iam_service_account_key.admin_sa_key.public_key
        private_key = yandex_iam_service_account_key.admin_sa_key.private_key
    })
    filename = "${path.module}/${var.dest_folder}/authorized_key.json"
}