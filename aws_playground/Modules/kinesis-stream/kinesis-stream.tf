
resource "aws_kinesis_stream" "my_stream" {
    
  name             = "terraform-kinesis-mystream"
  shard_count      = 1
  retention_period = 48

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]

  tags = {
    Environment = "test"
  }
}