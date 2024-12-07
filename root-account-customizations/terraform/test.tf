data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}

output "caller_user" {
  value = data.aws_caller_identity.current.user_id
}


resource "null_resource" "test" {
  # depends_on = [aws_organizations_policy_attachment.sandbox_whitelist_attachment_1,
  # aws_organizations_policy_attachment.sandbox_whitelist_attachment_2]

  provisioner "local-exec" {
    #    command = "aws organizations detach-policy --policy-id p-FullAWSAccess --target-id ${aws_organizations_organizational_unit.sandbox_whitelist.id}
    command = "aws sts get-caller-identity"
  }
}
