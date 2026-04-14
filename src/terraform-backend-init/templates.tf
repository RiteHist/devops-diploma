resource "local_file" "backend" {
    content = templatefile("${path.module}/backend.tftpl", {
        dynamodb = yandex_ydb_database_serverless.tflock_db.document_api_endpoint
        bucket = yandex_storage_bucket.backend_bucket.id
        dynamodb_table = yandex_ydb_table.tflock_table.path
    })
    filename = "${path.module}/../terraform-main-infra/backend.hcl"
}

resource "local_file" "tfinit" {
    content = templatefile("${path.module}/tfinit.tftpl", {
        access_key = yandex_iam_service_account_static_access_key.sa_key.access_key
        secret_key = yandex_iam_service_account_static_access_key.sa_key.secret_key
    })
    filename = "${path.module}/../terraform-main-infra/tfinit.sh"
}