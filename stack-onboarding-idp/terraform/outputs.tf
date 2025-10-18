output "bucket_name" {
  value = "${var.cy_child_org}-terraform-remote-state"
}

output "iam_user_access_key" {
  value = aws_iam_access_key.org.id
}