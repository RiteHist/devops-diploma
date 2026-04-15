variable "zone" {
    type = string
    description = "Зона доступности"
}

variable "dynamodb" {
    type = string
    description = "Document API эндпоинт БД"
}

variable "table_name" {
    type = string
    description = "Название таблицы в БД"
}

variable "attribute_name" {
    type = string
    description = "Название аттрибута (колонки) в таблице"
}

variable "attribute_type" {
    type = string
    description = "Тип аттрибута (колонки) в таблице"
}