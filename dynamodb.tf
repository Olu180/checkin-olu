# Create a DynamoDB table.
resource "aws_dynamodb_table" "user_check_in" {
  name           = var.dynamodb_table_name
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "Username"

  attribute {
    name = "Username"
    type = "S"
  }

  server_side_encryption {
   enabled = true 
  }
}