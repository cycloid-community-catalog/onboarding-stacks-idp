#
# Terraform backend
#
module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "${var.cy_child_org_canonical}-terraform-remote-state"
  
  # To allow destruction of a non-empty bucket
  force_destroy = true

  tags = {
    Name = "${var.cy_child_org_canonical}-terraform-remote-state"
    role = "s3"
  }
}

resource "aws_iam_user" "child_org" {
  name = var.cy_child_org_canonical
  path = "/organization/"

  tags = {
    Name = "${var.cy_child_org_canonical}"
    role = "user"
  }
}

resource "aws_iam_user_login_profile" "child_org" {
  user    = aws_iam_user.child_org.name
}

resource "aws_iam_access_key" "child_org" {
  user    = aws_iam_user.child_org.name
}

data "aws_iam_policy_document" "child_org" {
  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:s3:::${var.cy_child_org_canonical}-terraform-remote-state"]
    actions   = ["s3:ListBucket"]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:s3:::${var.cy_child_org_canonical}-terraform-remote-state/*"]

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:DeleteObject",
      "s3:DeleteObjectVersion",
    ]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "kms:GenerateDataKey",
      "sts:GetCallerIdentity",
      "ec2:DescribeRegions",
      "kms:Decrypt",
    ]
  }
}

resource "aws_iam_user_policy" "child_org" {
  name = "${var.cy_child_org_canonical}-s3-user"
  user = aws_iam_user.child_org.name

  policy = data.aws_iam_policy_document.child_org.json
}

resource "cycloid_credential" "s3-cycloid" {
  name                   = "s3-cycloid"
  description            = "AWS IAM user credential allowing access to an S3 bucket used as Terraform backend for your Cycloid organization."
  organization_canonical = var.cy_child_org_canonical
  path                   = "s3-cycloid"
  canonical              = "s3-cycloid"
  owner                  = var.project_owner

  type = "aws"
  body = {
    access_key = aws_iam_access_key.child_org.id
    secret_key = aws_iam_access_key.child_org.secret
  }
}

resource "time_sleep" "wait_30_seconds" {
  depends_on = [
    aws_iam_access_key.child_org,
    cycloid_credential.s3-cycloid,
    module.s3_bucket
  ]

  create_duration = "30s"
}

resource "cycloid_external_backend" "tf_external_backend" {
  organization_canonical = var.cy_child_org_canonical
  credential_canonical = cycloid_credential.s3-cycloid.canonical
  default = true
  purpose = "remote_tfstate"
  engine  = "aws_storage"
  aws_storage = {
    bucket = "${var.cy_child_org_canonical}-terraform-remote-state"
    region = var.aws_region
    endpoint = "https://s3.${var.aws_region}.amazonaws.com"
    s3_force_path_style = false
    skip_verify_ssl = true
  }
  depends_on = [time_sleep.wait_30_seconds]
}