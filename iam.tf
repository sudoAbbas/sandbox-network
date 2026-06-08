resource "aws_iam_instance_profile" "nat_instance_profile" {
  name = "mat_instance_profile"
  role = aws_iam_role.nat_role.name
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
  statement {
    effect  = "Allow"
    actions = ["s3:*"]
  }
}

resource "aws_iam_role" "nat_role" {
  name               = "mat_role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}