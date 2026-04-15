Данная конфигурация terraform создает базовые ресурсы на Yandex Cloud для использования в качестве бэкэнда для других terraform проектов. Вместе с ресурсами в облаке, создаются файл конфигурации бэкэнда `backend.hcl`, `authorized_key.json` с данными ключа сервисного аккаунта с админскими правами в каталоге облака и shell скрипт для запуска `terraform init` с данными сервисного аккаунта с правами на бакет и таблицу tflock.


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~>1.9.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | 2.8.0 |
| <a name="provider_yandex"></a> [yandex](#provider\_yandex) | 0.197.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_tflock_table"></a> [tflock\_table](#module\_tflock\_table) | ./ydb-table | n/a |

## Resources

| Name | Type |
|------|------|
| [local_file.authorized_key](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.backend](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.tfinit](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [yandex_iam_service_account.admin_sa](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/iam_service_account) | resource |
| [yandex_iam_service_account.state_sa](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/iam_service_account) | resource |
| [yandex_iam_service_account_key.admin_sa_key](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/iam_service_account_key) | resource |
| [yandex_iam_service_account_static_access_key.tf_sa_key](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/iam_service_account_static_access_key) | resource |
| [yandex_resourcemanager_folder_iam_binding.folder_admin](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/resourcemanager_folder_iam_binding) | resource |
| [yandex_storage_bucket.backend_bucket](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/storage_bucket) | resource |
| [yandex_storage_bucket_iam_binding.bucket_iam](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/storage_bucket_iam_binding) | resource |
| [yandex_ydb_database_iam_binding.ydb_iam](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/ydb_database_iam_binding) | resource |
| [yandex_ydb_database_serverless.tflock_db](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/ydb_database_serverless) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_params"></a> [bucket\_params](#input\_bucket\_params) | Параметры s3 бакета | <pre>object({<br/>        prefix = string<br/>        max_size = number<br/>        force_destroy = bool<br/>    })</pre> | <pre>{<br/>  "force_destroy": true,<br/>  "max_size": 10485760,<br/>  "prefix": "tfstate"<br/>}</pre> | no |
| <a name="input_cloud_id"></a> [cloud\_id](#input\_cloud\_id) | ID облака | `string` | n/a | yes |
| <a name="input_dest_folder"></a> [dest\_folder](#input\_dest\_folder) | Относительный путь до каталога, где должны создаться файлы конфигурации бэкэнда | `string` | `"../terraform-main-infra"` | no |
| <a name="input_folder_id"></a> [folder\_id](#input\_folder\_id) | ID каталога в облаке | `string` | n/a | yes |
| <a name="input_roles"></a> [roles](#input\_roles) | Список ролей для сервисных аккаунтов | `list(string)` | <pre>[<br/>  "storage.editor",<br/>  "ydb.editor",<br/>  "admin"<br/>]</pre> | no |
| <a name="input_sa_names"></a> [sa\_names](#input\_sa\_names) | Список имен сервисных аккаунтов | `list(string)` | <pre>[<br/>  "terraform-state",<br/>  "terraform-admin"<br/>]</pre> | no |
| <a name="input_ydb_params"></a> [ydb\_params](#input\_ydb\_params) | Параметры YDB и создаваемой таблицы | <pre>object({<br/>      name = string<br/>      deletion_protection = bool<br/>      storage_size_limit = number<br/>      enable_throttling_rcu_limit = bool<br/>      provisioned_rcu_limit = number<br/>      throttling_rcu_limit = number<br/>      table_path = string<br/>      table_column_name = string<br/>      table_column_type = string<br/>    })</pre> | <pre>{<br/>  "deletion_protection": false,<br/>  "enable_throttling_rcu_limit": true,<br/>  "name": "terraform-lock",<br/>  "provisioned_rcu_limit": 0,<br/>  "storage_size_limit": 1,<br/>  "table_column_name": "LockID",<br/>  "table_column_type": "S",<br/>  "table_path": "tflock",<br/>  "throttling_rcu_limit": 10<br/>}</pre> | no |
| <a name="input_zone"></a> [zone](#input\_zone) | Дефолтная зона доступности | `string` | `"ru-central1-a"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
