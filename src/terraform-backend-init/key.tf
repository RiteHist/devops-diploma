resource "yandex_iam_service_account_static_access_key" "sa_key" {
    service_account_id = yandex_iam_service_account.state_sa.id
}