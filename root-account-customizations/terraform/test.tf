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

#        --role-arn "arn:aws:iam::195094525803:role/AWSAFTExecution" \

resource "null_resource" "assume_role_command4" {
  provisioner "local-exec" {
    environment = {
      CALLER_ARN = data.aws_caller_identity.current.arn
    }
    command = <<EOF
      echo "Vended exec role arn: $VENDED_EXEC_ROLE_ARN"
      echo "Caller ARN: $CALLER_ARN"

      temp_role="$(aws sts assume-role \
        --role-arn "$VENDED_EXEC_ROLE_ARN"
        --role-session-name "terraform-session-null-exec" \
        --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]' \
        --output text)"

      read AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN <<< $temp_role
      export AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN

      aws sts get-caller-identity
      unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN temp_role
    EOF

    interpreter = ["/bin/bash", "-c"]
  }
}
