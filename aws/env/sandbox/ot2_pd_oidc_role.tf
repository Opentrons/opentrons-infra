data "aws_iam_openid_connect_provider" "github_actions" {
  url = "https://token.actions.githubusercontent.com"
}

resource "aws_iam_role" "githubuser_ot2_role_sandbox_default" {
  name        = "githubuser_ot2_role-sandbox-default"
  description = "OIDC role for OT2 Protocol Designer sandbox deploys from Opentrons/opentrons-ot2"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRoleWithWebIdentity"
        Principal = {
          Federated = data.aws_iam_openid_connect_provider.github_actions.arn
        }
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:Opentrons/opentrons-ot2:*"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "githubuser_ot2_role_sandbox_default_policy" {
  name = "githubuser_ot2_role-sandbox-default-policy"
  role = aws_iam_role.githubuser_ot2_role_sandbox_default.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowBucketLevelOpsForSandboxOt2PdBucket"
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ]
        Resource = [module.ot2_protocol_designer_bucket.bucket_arn]
      },
      {
        Sid    = "AllowObjectLevelOpsForSandboxOt2PdBucket"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:AbortMultipartUpload"
        ]
        Resource = ["${module.ot2_protocol_designer_bucket.bucket_arn}/*"]
      },
      {
        Sid    = "AllowCloudFrontInvalidationsForSandboxOt2Pd"
        Effect = "Allow"
        Action = [
          "cloudfront:GetDistribution",
          "cloudfront:GetInvalidation",
          "cloudfront:CreateInvalidation"
        ]
        Resource = [module.ot2_protocol_designer_cloudfront_distribution.distribution_arn]
      }
    ]
  })
}
