terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

terraform {
  backend "s3" {
    bucket         = "ernesto-reig-terraform-st"
    key            = "stage/data-stores/mysql/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

resource "aws_db_instance" "example" {
  identifier_prefix   = "ernesto-reig-tf-"
  allocated_storage   = 10
  instance_class      = "db.t2.micro"
  skip_final_snapshot = true

  # Enable backups
  backup_retention_period = var.backup_retention_period

  # If specified, this DB will be a replica
  replicate_source_db     = var.replicate_source_db

  # Only specify these params if replicate_source_db is not set
  engine   = var.replicate_source_db == null? "mysql" : null
  db_name  = var.replicate_source_db == null? var.db_name : null
  username = var.replicate_source_db == null? var.username : null
  password = var.replicate_source_db == null? var.username : null
}