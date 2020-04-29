data "aws_elb_service_account" "main" {}
 

resource "aws_s3_bucket" "lb_logs" {
  bucket = var.name
  acl    = "private"
  force_destroy = true
  policy = <<POLICY
{
  "Id": "Policy",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${var.name}/${var.prefix}/*",
      "Principal": {
        "AWS": [
          "${data.aws_elb_service_account.main.arn}"
        ] 
      }
    }
  ]
}
POLICY
}
 