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


resource "null_resource" "assume_role_command2" {
  provisioner "local-exec" {
    command = <<EOF

      temp_role="$(aws sts assume-role \
        --role-arn "arn:aws:iam::195094525803:role/AWSAFTExecution" \
        --role-session-name "terraform-session-null-exec" \
        --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]' \
        --output text)"

      read AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN <<< $temp_role
      export AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN

      aws sts get-caller-identity
      if [[ -z ~/.aws/config ]]; then
        cat ~/.aws/config
      else
        echo "~/.aws/config not found"
      fi
      
    EOF

    interpreter = ["/bin/bash", "-c"]
  }
}
