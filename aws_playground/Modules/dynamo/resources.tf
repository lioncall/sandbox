
resource "aws_dynamodb_table" "table" {
   
  hash_key         = var.hash_key
  name             = var.name
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"
  read_capacity    = 1
  write_capacity   = 1

  attribute {
    name = var.hash_key
    type = var.type
  }

  tags = merge(var.common_tags, { Name = "dynamodb-${var.name}" })
}