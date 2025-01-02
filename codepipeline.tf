resource "aws_codebuild_project" "tf-plan" {
  name          = "tf-codebuild-plan"
  service_role  = aws_iam_role.cicd_codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "hashicorp/terraform"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "SERVICE_ROLE"
    registry_credential{
        credential = var.dockerhub_credentials
        credential_provider = "SECRETS_MANAGER"
    }
  }

  

  source {
     type   = "CODEPIPELINE"
     buildspec = file("buildspec/plan-buildspec.yml")
 }

}

resource "aws_codebuild_project" "tf-apply" {
  name          = "tf-codebuild-apply"
  service_role  = aws_iam_role.cicd_codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "hashicorp/terraform"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "SERVICE_ROLE"
    registry_credential{
        credential = var.dockerhub_credentials
        credential_provider = "SECRETS_MANAGER"
    }
  }

  source {
     type   = "CODEPIPELINE"
     buildspec = file("buildspec/apply-buildspec.yml")
 }

}


resource "aws_codepipeline" "cicd_pipeline" {
  name     = "tf-cicd-pipeline"
  role_arn = aws_iam_role.cicd_codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_artifacts.id
    type     = "S3"

    
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = var.codestar_connector_credentials
        FullRepositoryId = "soumithrajkovuri/terraform-cicd-pipeline"
        BranchName       = "main"
      }
    }
  }

  stage {
    name = "Plan"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["plan_output"]
      version          = "1"

      configuration = {
        ProjectName = "tf-cicd-plan"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CloudBuild"
      input_artifacts = ["source_output"]
      version         = "1"

      configuration = {
        ProjectName = "tf-cicd-apply"
      }
    }
  }
}