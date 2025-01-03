resource "aws_iam_role" "cicd_codepipeline_role" {
  name = "cicd_codepipeline_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "cicd_codepipeline_policy" {
  name = "cicd_codepipeline_policy"
  role = aws_iam_role.cicd_codepipeline_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["codestar-connections:UseConnection"]
        Resource = ["*"]
        Effect   = "Allow"
      },
      {
        Action   = ["cloudwatch:*", "s3:*", "codebuild:*"]
        Resource = ["*"]
        Effect   = "Allow"
      }
    ]
  })
}

resource "aws_iam_role" "cicd_codebuild_role" {
  name = "cicd_codebuild_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "cicd_codebuild_policy" {
  name = "cicd_codebuild_policy"
  role = aws_iam_role.cicd_codebuild_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["logs:*", "s3:*", "codebuild:*", "secretsmanager:*", "iam:*","codepipeline:GetPipeline"]
        Resource = ["*"]
        Effect   = "Allow"
      }
    ]
  })
}
