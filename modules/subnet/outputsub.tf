output "subnet_id" {
  value = aws_subnet.this.id
}

 
output "cidr_block" {
  value       = aws_subnet.this.cidr_block
  description = "CIDR du subnet"
}

output "availability_zone" {
  value       = aws_subnet.this.availability_zone
  description = "Zone de disponibilité"
}