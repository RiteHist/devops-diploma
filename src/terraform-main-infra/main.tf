terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = "~>1.9.1"
  backend "s3" {
    endpoints = {
      s3 = ""
      dynamodb = ""
    }
    bucket = ""
    region = ""
    key = ""

    skip_region_validation = true
    skip_credentials_validation = true
    skip_requesting_account_id = true
    skip_s3_checksum = true
    
    dynamodb_table = ""
  }
}

provider "yandex" {
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone_list[0]
  service_account_key_file = file("./authorized_key.json")
}