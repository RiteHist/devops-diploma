resource "yandex_iam_service_account_static_access_key" "tf_sa_key" {
    service_account_id = yandex_iam_service_account.state_sa.id
}

resource "yandex_iam_service_account_key" "admin_sa_key" {
    service_account_id = yandex_iam_service_account.admin_sa.id
}