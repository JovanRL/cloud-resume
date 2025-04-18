resource "aws_dynamodb_table" "visitsDB" {
  name             = "visits"
  hash_key         = "userID"
  billing_mode     = "PAY_PER_REQUEST"
  range_key        = "visitDate"

  attribute {
    name = "userID"
    type = "S"
  }

  attribute {
    name = "visitDate"
    type = "S"
  }

    global_secondary_index {
    name               = "visitDate"
    hash_key           = "visitDate"
    projection_type    = "ALL"
  }
}