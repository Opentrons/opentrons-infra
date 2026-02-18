data "aws_iam_openid_connect_provider" "github_actions" {
  url = "https://token.actions.githubusercontent.com"
}

resource "aws_iam_role" "githubuser_ot2_role_staging_default" {
  name        = "githubuser_ot2_role-staging-default"
  description = "OIDC role for OT2 Protocol Designer staging deploys from Opentrons/opentrons-ot2"

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

resource "aws_iam_role_policy" "githubuser_ot2_role_staging_default_policy" {
  name = "githubuser_ot2_role-staging-default-policy"
  role = aws_iam_role.githubuser_ot2_role_staging_default.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowBucketLevelOpsForStagingOt2PdBucket"
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ]
        Resource = [module.protocol_designer_bucket.bucket_arn]
      },
      {
        Sid    = "AllowObjectLevelOpsForStagingOt2PdBucket"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:AbortMultipartUpload"
        ]
        Resource = ["${module.protocol_designer_bucket.bucket_arn}/*"]
      },
      {
        Sid    = "AllowCloudFrontInvalidationsForStagingOt2Pd"
        Effect = "Allow"
        Action = [
          "cloudfront:GetDistribution",
          "cloudfront:GetInvalidation",
          "cloudfront:CreateInvalidation"
        ]
        Resource = [module.protocol_designer_cloudfront_distribution.distribution_arn]
      }
    ]
  })
}
