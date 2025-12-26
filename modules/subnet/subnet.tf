resource "aws_subnet" "this" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.cidr_block
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = var.public

  tags = {
    Name = var.public ? "public-subnet" : "private-subnet"
  }
}
