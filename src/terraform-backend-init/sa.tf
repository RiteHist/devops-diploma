resource "yandex_iam_service_account" "state_sa" {
    name = var.sa_names[0]
}

resource "yandex_iam_service_account" "admin_sa" {
    name = var.sa_names[1]
}

resource "yandex_storage_bucket_iam_binding" "bucket_iam" {
    bucket = yandex_storage_bucket.backend_bucket.id
    role = var.roles[0]

    members = [
        "serviceAccount:${yandex_iam_service_account.state_sa.id}"
    ]
}

resource "yandex_ydb_database_iam_binding" "ydb_iam" {
    database_id = yandex_ydb_database_serverless.tflock_db.id
    role = var.roles[1]

    members = [
        "serviceAccount:${yandex_iam_service_account.state_sa.id}"
    ]
}

resource "yandex_resourcemanager_folder_iam_binding" "folder_admin" {
    folder_id = var.folder_id
    role = var.roles[2]

    members = [
        "serviceAccount:${yandex_iam_service_account.admin_sa.id}"
    ]
}