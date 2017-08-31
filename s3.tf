resource "aws_s3_bucket" "terraform-sample-tfstate" {
    bucket = "terraform-sample-tfstate"
    acl = "private"
}

