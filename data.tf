data "aws_vpc" "vpc-kuikvengers" {
  id = "vpc-0e2057eab81a540b2"
}

data "aws_internet_gateway" "igw" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.vpc-kuikvengers.id]
  }
}

data "aws_nat_gateway" "nat-gateway" {
 
  filter {
   name   = "vpc-id"
   values = [data.aws_vpc.vpc-kuikvengers.id]
  }
  filter {
   name   = "tag:Name"
   values = ["kuikvengers_NAT_GeneralUse"]
    }
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_key_pair" "cle-kuikvengers-Mammar" {
  key_name = "kuikvengers_Mammar"
}

data "aws_ami" "ubuntu_latest" {
  most_recent = true
  owners      = ["099720109477"]   

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}


data "aws_ami" "amazon_linux_latest" {
  most_recent = true
  owners      = ["137112412989"] # Amazon

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

 

