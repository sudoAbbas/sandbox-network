data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "nat_role" {
  name               = "nat_role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_instance_profile" "nat_instance_profile" {
  name = "nat_instance_profile"
  role = aws_iam_role.nat_role.name
}

resource "aws_iam_policy" "nat_s3_policy" {
  name        = "nat_s3_policy"
  description = "Allow S3 access from NAT instance"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:*"]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "nat_s3_attach" {
  role       = aws_iam_role.nat_role.name
  policy_arn = aws_iam_policy.nat_s3_policy.arn
}