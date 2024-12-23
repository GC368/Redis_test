region                = "ap-southeast-2"
ami                   = "ami-0146fc9ad419e2cfd"
instance_type         = "t3.medium"
vpc_id                = "vpc-03758285498e68326"
subnet_id             = "subnet-0864fc1de50ab39a9"
ssh_cidr_blocks       = ["0.0.0.0/0"] 
redis_cidr_blocks     = ["0.0.0.0/0"] 
key_pair_name         = "Redis-key-pair"


# # Default Tags
# variable "tags" {
#   description = "A map of default tags to assign to all AWS resources"
#   type        = map(string)
#   default = {
#     Environment = "development"
#     Project     = "redis-server"
#   }
# }






