terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.78"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
  required_version = ">= 1.10.0"
}

provider "aws" {
  region = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_instance" "redis_server" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_pair_name  
  vpc_security_group_ids = [aws_security_group.redis_sg.id]
  subnet_id              = var.subnet_id
  tags = merge(
    var.tags,
    { Name = "Redis Server" }
  )
}


# Create Security Group
resource "aws_security_group" "redis_security_group" {
  name        = "redis_sg"
  description = "Allow Redis and SSH access"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_cidr_blocks
  }

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = var.redis_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    { Name = "redis-security-group" }
  )
}


