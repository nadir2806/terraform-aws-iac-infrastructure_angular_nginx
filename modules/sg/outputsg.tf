output "security_group_id" {
  value       = aws_security_group.this.id
  description = "ID du security group"  
}

 
output "security_group_name" {
  value       = aws_security_group.this.name
  description = "Nom du security group"
}