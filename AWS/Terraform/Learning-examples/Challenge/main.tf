terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.7"
    }
  }
  backend "s3" {
    bucket         = "terraformstate-3ce7b385"
    key            = "samunas/us-west-2/lab/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "challenge" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "challenge" {
  vpc_id            = aws_vpc.challenge.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"
}


resource "aws_instance" "server1" {
  ami                    = "ami-01fee56b22f308154"
  instance_type          = var.instance_size
  monitoring             = false
  vpc_security_group_ids = [aws_vpc.challenge.default_security_group_id]
  subnet_id              = aws_subnet.challenge.id
  root_block_device {
    delete_on_termination = false
    encrypted             = true
    volume_size           = "8"
    volume_type           = "standard"
  }
  tags = {
    Name = "cloudacademylabs"
  }
}