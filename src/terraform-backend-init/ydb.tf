resource "yandex_ydb_database_serverless" "tflock_db" {
    name = var.ydb_params.name
    deletion_protection = var.ydb_params.deletion_protection
    serverless_database {
      enable_throttling_rcu_limit = var.ydb_params.enable_throttling_rcu_limit
      provisioned_rcu_limit = var.ydb_params.provisioned_rcu_limit
      storage_size_limit = var.ydb_params.storage_size_limit
      throttling_rcu_limit = var.ydb_params.throttling_rcu_limit
    }
}

# resource "yandex_ydb_table" "tflock_table" {
#     path = var.ydb_params.table_path
#     connection_string = yandex_ydb_database_serverless.tflock_db.ydb_full_endpoint
#     column {
#       name = var.ydb_params.table_column_name
#       type = var.ydb_params.table_column_type
#     }

#     store = "column"

#     primary_key = ["${var.ydb_params.table_column_name}"]
# }

module "tflock_table" {
  source = "./ydb-table"
  zone = var.zone
  dynamodb = yandex_ydb_database_serverless.tflock_db.document_api_endpoint
  table_name = var.ydb_params.table_path
  attribute_name = var.ydb_params.table_column_name
  attribute_type = var.ydb_params.table_column_type
}