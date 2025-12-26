variable "vpc_id" {
  type = string
  description = "L'ID du VPC où créer le subnet"
}

variable "cidr_block" {
  type = string
  description = "Le bloc CIDR du subnet"
}

variable "availability_zone" {
  type = string
  description = "Zone de disponibilité du subnet"
}

variable "public" {
  type = bool
  description = "Indique si le subnet est public ou non (map_public_ip_on_launch)"
}
