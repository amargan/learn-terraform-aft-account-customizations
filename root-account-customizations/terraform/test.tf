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

#############################

# resource "aws_organizations_organizational_unit" "sandbox_whitelist" {
#   name = "Sandbox-Whitelist"
#   #  parent_id = data.aws_ssm_parameter.sandbox_ou.value
#   parent_id = "r-xg04"
# }

# resource "aws_organizations_policy" "sandbox_whitelist_1" {
#   name        = "sandbox-whitelist-1"
#   description = "Sandbox Whitelist SCP1"
#   content     = file("policies/scp/sandbox-whitelist-ou-scp1.json")
# }

# resource "aws_organizations_policy_attachment" "sandbox_whitelist_attachment_1" {
#   policy_id = aws_organizations_policy.sandbox_whitelist_1.id
#   target_id = aws_organizations_organizational_unit.sandbox_whitelist.id

#   provisioner "local-exec" {
#     environment = {
#       AWS_PROFILE  = "aft-target"
#       target_ou_id = aws_organizations_organizational_unit.sandbox_whitelist.id
#     }

#     interpreter = ["/bin/bash", "-c"]
#     command     = "aws organizations detach-policy --policy-id p-FullAWSAccess --target-id $target_ou_id"
#   }

#   provisioner "local-exec" {
#     when = destroy

#     environment = {
#       AWS_PROFILE  = "aft-target"
#       target_ou_id = "ou-xg04-2moiegb6"
#     }

#     interpreter = ["/bin/bash", "-c"]
#     command     = "aws organizations attach-policy --policy-id p-FullAWSAccess --target-id $target_ou_id"
#   }

# }


# resource "aws_organizations_policy" "sandbox_whitelist_2" {
#   name        = "sandbox-whitelist-2"
#   description = "Sandbox Whitelist SCP2"
#   content     = file("policies/scp/sandbox-whitelist-ou-scp2.json")
# }

# resource "aws_organizations_policy_attachment" "sandbox_whitelist_attachment_2" {
#   depends_on = [
#     aws_organizations_policy_attachment.sandbox_whitelist_attachment_1
#   ]
#   policy_id = aws_organizations_policy.sandbox_whitelist_2.id
#   target_id = aws_organizations_organizational_unit.sandbox_whitelist.id
# }



#######################################################################################

# resource "null_resource" "example1" {
#   provisioner "local-exec" {
#     environment = {
#       AWS_PROFILE = "aft-target"
#     }

#     interpreter = ["/bin/bash", "-c"]
#     command     = "aws sts get-caller-identity"
#   }
# }


# resource "null_resource" "test" {
#   depends_on = [aws_organizations_policy_attachment.sandbox_whitelist_attachment_1,
#   aws_organizations_policy_attachment.sandbox_whitelist_attachment_2]

#   provisioner "local-exec" {
#     command = "aws organizations detach-policy --policy-id p-FullAWSAccess --target-id ${aws_organizations_organizational_unit.sandbox_whitelist.id}"
#   }
# }

