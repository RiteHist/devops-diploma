resource "yandex_iam_service_account" "state_sa" {
    name = var.sa_name
}

resource "yandex_storage_bucket_iam_binding" "bucket_iam" {
    bucket = yandex_storage_bucket.backend_bucket.id
    role = "storage.editor"

    members = [
        "serviceAccount:${yandex_iam_service_account.state_sa.id}"
    ]
}

resource "yandex_ydb_database_iam_binding" "ydb_iam" {
    database_id = yandex_ydb_database_serverless.tflock_db.id
    role = "ydb.editor"

    members = [
        "serviceAccount:${yandex_iam_service_account.state_sa.id}"
    ]
}