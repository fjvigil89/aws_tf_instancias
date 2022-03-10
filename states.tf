terraform {
  backend "s3" {
    bucket         = "test-aws-tf-local-bucket"
    key            = "terraform.tfstate"
    encrypt        = true
    
#    region         		= "eu-central-1"
#    profile        		= "test_local"
#    shared_credentiales_file 	= "THE_ID_OF_THE_DYNAMODB_TABLE"
  }
}


