resource "random_string" "this_default" {
  length  = 8
  special = false
  upper   = false
  numeric = true
}

module "resource_group_default" {
  source   = "../../"
  name     = format("tfrgtest-%s", random_string.this_default.result)
  location = "canadacentral"
  tags = {
    ManagedBy = "Terraform",
    Test      = random_string.this_default.result
  }
}
