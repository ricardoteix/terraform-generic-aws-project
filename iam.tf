# IAM Role # aws_efs_file_system.projeto-efs.arn
resource "aws_iam_role" "projeto-role" {
  name = "${var.tag-base}-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Sid    = ""
          Principal = {
            Service = "ec2.amazonaws.com"
          }
        },
      ]
    }
  )
  tags = {
    Name = "${var.tag-base}-role"
  }
}

resource "aws_iam_instance_profile" "projeto-profile" {
  name = "${var.tag-base}-profile"
  role = aws_iam_role.projeto-role.name
}

resource "aws_iam_role_policy" "projeto-policy" {
  name = "${var.tag-base}-policy"
  role = aws_iam_role.projeto-role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "sns:Publish",
                "s3:ListBucket",
                "elasticfilesystem:DescribeFileSystems"
            ],
            "Resource": [
                "arn:aws:s3:::${var.nome-bucket}",
                "arn:aws:elasticfilesystem:*:930779231265:file-system/*",
                "${aws_sns_topic.projeto-events.arn}"
            ]
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject",
                "s3:DeleteObject"
            ],
            "Resource": "arn:aws:s3:::${var.nome-bucket}/*"
        }
    ]
}
EOF
}