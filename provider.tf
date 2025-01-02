terraform{
    backend "s3" {
        bucket = "soumith-cicd-pipeline-bucket"
        encrypt = true
        key = "terraform.tfstate"
        region = "us-east-1"
    }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}