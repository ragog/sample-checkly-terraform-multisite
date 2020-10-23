variable "checkly_api_key" {}

terraform {
  required_providers {
    checkly = {
      source = "checkly/checkly"
      version = "0.7.1"
    }
  }
}

provider "checkly" {
  api_key = var.checkly_api_key
}

resource "checkly_check" "browser-check-1" {
  for_each = fileset("${path.module}/scripts", "*")

  name                      = each.key
  type                      = "BROWSER"
  activated                 = true
  should_fail               = false
  frequency                 = 10
  double_check              = true
  ssl_check                 = false
  use_global_alert_settings = true
  locations = [
    "us-west-1"
  ]

  script = file("${path.module}/scripts/${each.key}")
  group_id = checkly_check_group.group-for-website1.id

}

resource "checkly_check" "browser-check-2" {
  for_each = fileset("${path.module}/scripts", "*")

  name                      = each.key
  type                      = "BROWSER"
  activated                 = true
  should_fail               = false
  frequency                 = 30
  double_check              = false
  ssl_check                 = true
  use_global_alert_settings = true
  locations = [
    "us-west-1"
  ]

  script = file("${path.module}/scripts/${each.key}")
  group_id = checkly_check_group.group-for-website2.id

}


resource "checkly_check_group" "group-for-website1" {
  name      = "Website 1"
  activated = true
  muted     = false

  locations = [
    "eu-west-1", "us-east-1"
  ]
  concurrency = 3
  environment_variables = {
    TARGET_URL = "https://checklyhq.com"
  }
  double_check              = true
  use_global_alert_settings = false

}

resource "checkly_check_group" "group-for-website2" {
  name      = "Website 2"
  activated = true
  muted     = false

  locations = [
    "eu-west-1", "us-east-1"
  ]
  concurrency = 3
  environment_variables = {
    TARGET_URL = "https://checklyhq.com/docs"
  }
  double_check              = true
  use_global_alert_settings = false

}