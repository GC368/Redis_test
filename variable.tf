# AWS Region
variable "region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "ap-southeast-2"
}

# AMI for EC2 Instance
variable "ami" {
  description = "The AMI ID to use for the EC2 instance"
  type        = string
  default     = "ami-0146fc9ad419e2cfd"
}

# EC2 Instance Type
variable "instance_type" {
  description = "The instance type for the EC2 instance"
  type        = string
  default     = "t3.medium"
}


# Vpc ID
variable "vpc_id" {
  description = "ID of the existing VPC"
  default     = "vpc-d8909dbc"
}

# subnet ID
variable "subnet_id" {
  description = "ID of the existing subnet"
  default     = "subnet-6f9a5a26"
}


# CIDR Blocks for SSH Access
variable "ssh_cidr_blocks" {
  description = "The CIDR blocks allowed for SSH access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

# CIDR Blocks for Redis Access
variable "redis_cidr_blocks" {
  description = "The CIDR blocks allowed for Redis access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

# Default Tags
variable "tags" {
  description = "A map of default tags to assign to all AWS resources"
  type        = map(string)
  default = {
    Environment = "development"
    Project     = "redis-server"
  }
}

variable "key_pair_name" {
  description = "The name of the existing Key Pair"
  type        = string
  default     = "jr-uat-2024"
}

variable "aws_access_key" {
    description = "AWS Access Key"
    type        = string
}

variable "aws_secret_key" {
    description = "AWS Secret Key"
    type        = string
}




