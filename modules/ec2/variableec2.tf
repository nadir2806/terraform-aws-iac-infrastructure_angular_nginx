variable "ami_id" {
  type = string
  default = ""
}

variable "instance_type" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "security_group_id" {
  type = string
}

variable "key_name" {
  type = string
}

variable "associate_public_ip" {
  type = bool
}

variable "user_data" {
  type = string
  default = ""
}
