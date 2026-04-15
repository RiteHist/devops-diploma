terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

provider "aws" {
    region = var.zone
    endpoints {
        dynamodb = var.dynamodb
    }
    profile = var.table_name
    skip_credentials_validation = true
    skip_metadata_api_check = true
    skip_region_validation = true
    skip_requesting_account_id = true
}

resource "aws_dynamodb_table" "tflock_table" {
    name = var.table_name
    billing_mode = "PAY_PER_REQUEST"

    hash_key = var.attribute_name

    attribute {
        name = var.attribute_name
        type = var.attribute_type
    }
}