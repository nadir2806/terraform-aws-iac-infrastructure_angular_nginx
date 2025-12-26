variable "region" {
  description = "la region ou il est Aws"
  type        = string
}

variable "instance_type" {
  type        = string
  description = "Type d'instance EC2"
}

variable "cidre-block-private" {
    type        = string
    description = "Bloc CIDR pour les règles de sécurité"
}

variable "cidre-block-public" {
    type        = string
    description = "Bloc CIDR pour les règles de sécurité"
}

