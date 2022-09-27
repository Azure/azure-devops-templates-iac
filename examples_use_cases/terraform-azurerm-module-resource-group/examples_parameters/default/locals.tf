locals {
  tags = {
    ManagedBy = "Terraform",
    Test      = random_string.this_default.result
  }
}
