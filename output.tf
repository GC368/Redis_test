# Output private IP
output "instance_private_ip" {
  value = aws_instance.redis_server.private_ip
}

# Output public IP
output "instance_public_ip" {
  value       = aws_instance.redis_server.public_ip
  description = "The public IP address of the Redis server"
}