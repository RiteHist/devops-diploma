Модуль используется для создания документой таблицы в Yandex Cloud, потому что они нехорошие люди и не могут написать необходимый ресурс в своем провайдере. Для корректного использования необходим файл `credentials` в каталоге `~/.aws` содержащий профиль `tflock` с данными о статическом ключе.
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_dynamodb_table.tflock_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_attribute_name"></a> [attribute\_name](#input\_attribute\_name) | Название аттрибута (колонки) в таблице | `string` | n/a | yes |
| <a name="input_attribute_type"></a> [attribute\_type](#input\_attribute\_type) | Тип аттрибута (колонки) в таблице | `string` | n/a | yes |
| <a name="input_dynamodb"></a> [dynamodb](#input\_dynamodb) | Document API эндпоинт БД | `string` | n/a | yes |
| <a name="input_table_name"></a> [table\_name](#input\_table\_name) | Название таблицы в БД | `string` | n/a | yes |
| <a name="input_zone"></a> [zone](#input\_zone) | Зона доступности | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_table_name"></a> [table\_name](#output\_table\_name) | n/a |
<!-- END_TF_DOCS -->