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


# resource "null_resource" "test" {
#   depends_on = [aws_organizations_policy_attachment.sandbox_whitelist_attachment_1,
#   aws_organizations_policy_attachment.sandbox_whitelist_attachment_2]

#   provisioner "local-exec" {
#     command = "aws organizations detach-policy --policy-id p-FullAWSAccess --target-id ${aws_organizations_organizational_unit.sandbox_whitelist.id}"
#   }
# }


resource "null_resource" "assume_role_command" {
  provisioner "local-exec" {
    command = <<EOF
      credentials=($(aws sts assume-role \
        --role-arn "arn:aws:iam::195094525803:role/AWSAFTExecution" \
        --role-session-name "terraform-session-null-exec" \
        --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]' \
        --output text))

      unset PROFILE
      export AWS_ACCESS_KEY_ID="${credentials[0]}"
      export AWS_SECRET_ACCESS_KEY="${credentials[1]}"
      export AWS_SESSION_TOKEN="${credentials[2]}"
      unset credentials
      
      aws sts get-caller-identity
    EOF

    interpreter = ["/bin/bash", "-c"]
  }
}

