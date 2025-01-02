 resource "aws_s3_bucket" "codepipeline_artifacts" {
  bucket = "pipeline-artifacts-soumith"
}

resource "aws_s3_bucket_ownership_controls" "codepipeline_artifacts" {
  bucket = aws_s3_bucket.codepipeline_artifacts.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "codepipeline_artifacts" {
  depends_on = [aws_s3_bucket_ownership_controls.codepipeline_artifacts]

  bucket = aws_s3_bucket.codepipeline_artifacts.id
  acl    = "private"
}