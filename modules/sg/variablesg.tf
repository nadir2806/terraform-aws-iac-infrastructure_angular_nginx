variable "vpc_id" {
  type = string
  description = "L'ID du VPC où créer le SG"
}

variable "ingress_ports" {
  type        = list(number)
  description = "Liste des ports TCP à ouvrir"
}

variable "name" {
  type        = string
  description = "Nom du security group"
  default     = "basic-sg"
}
