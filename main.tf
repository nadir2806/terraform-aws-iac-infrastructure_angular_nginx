#création du SUBNET public
 resource "aws_subnet" "Mammar-public-subnet" {
  vpc_id                  = data.aws_vpc.vpc-kuikvengers.id
  cidr_block              =  var.cidre-block-public
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]


  provisioner "local-exec" {
    command = "echo 'Subnet public créé avec succès dans le availability zone ${data.aws_availability_zones.available.names[0]}' > /tmp/subnet_creation.log"
  }

  tags = {
    Name = "Mammar-public-subnet"
  }

}
#Création du subnet privé

resource "aws_subnet" "Mammar-private-subnet" {
  vpc_id                  = data.aws_vpc.vpc-kuikvengers.id
  cidr_block              = var.cidre-block-private
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "Mammar-private-subnet"
  }
}
 
#Table de routage pour le subnet public

resource "aws_route_table" "Mammar-Policy-public" {
  vpc_id = data.aws_vpc.vpc-kuikvengers.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Mammar-public-route"
  }
}

#Association de routage pour le subnet public

resource "aws_route_table_association" "a-public-subnet" {
  subnet_id      = aws_subnet.Mammar-public-subnet.id
  route_table_id = aws_route_table.Mammar-Policy-public.id
}

#Table de routage pour le subnet privé

resource "aws_route_table" "Mammar-private-rt" {
  vpc_id = data.aws_vpc.vpc-kuikvengers.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = data.aws_nat_gateway.nat-gateway.id
  }

  tags = {
    Name = "Mammar-private-route"
  }
}
#Association de routage pour le subnet privé

resource "aws_route_table_association" "a-private-subnet" {
  subnet_id      = aws_subnet.Mammar-private-subnet.id
  route_table_id = aws_route_table.Mammar-private-rt.id
}


resource "aws_instance" "nginx_server" {
  ami                         = data.aws_ami.amazon_linux_latest.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.Mammar-private-subnet.id
  key_name                    = data.aws_key_pair.cle-kuikvengers-Mammar.key_name
  vpc_security_group_ids      = [aws_security_group.Mammar-Nginx-sg.id]
  associate_public_ip_address = false

  user_data = <<-EOF
              #!/bin/bash
              # Mettre à jour tous les packages
                yum update -y

            # Installer Nginx
            amazon-linux-extras install nginx1 -y

            # Démarrer Nginx
            systemctl start nginx
            systemctl enable nginx

                EOF

  tags = {
    Name = "Mammar-Nginx-Server"
  }
}


#Création du groupe de sécurité pour l'instance Nginx

resource "aws_security_group" "Mammar-Nginx-sg" {
  name        = "Mammar-Nginx-sg"
  description = "Security group for Nginx   server"
  vpc_id      = data.aws_vpc.vpc-kuikvengers.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.cidre-block-public]

  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.cidre-block-public]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Mammar-Nginx-sg"
  }
}


#Création du groupe de sécurité pour l'instance Angular

resource "aws_security_group" "Mammar-angular-sg" {
  name        = "Mammar-angular-sg"
  description = "Security group for Angular server"
  vpc_id      = data.aws_vpc.vpc-kuikvengers.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Mammar-angular-sg"
  }
}



#Création de l'instance EC2 pour héberger l'application Angular


resource "aws_instance" "angular_app" {
  ami                         = data.aws_ami.ubuntu_latest.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.Mammar-public-subnet.id
  key_name                    = data.aws_key_pair.cle-kuikvengers-Mammar.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.Mammar-angular-sg.id]

  user_data = <<-EOF
        #!/bin/bash
        apt update -y
        apt upgrade -y

        curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
        apt install -y nodejs

        npm install -g @angular/cli

        apt install -y python3 python3-pip

EOF



  provisioner "local-exec" {
    command = "echo ${self.public_ip} > /tmp/public_instance_ip.txt"
  }

  tags = {
    Name = "Mammar-AngularAppServer"
  }
}


























output "data-availability-zones" {
    value = data.aws_availability_zones.available.names
}
 

 # Subnet public
module "subnet_public" {
  source            = "./modules/subnet"
  vpc_id            = data.aws_vpc.vpc-kuikvengers.id
  cidr_block        = "10.0.111.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
  public            = true
}

# Subnet privé
module "subnet_private" {
  source            = "./modules/subnet"
  vpc_id            = data.aws_vpc.vpc-kuikvengers.id
  cidr_block        = "10.0.222.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
  public            = false
}

# Security Group public
module "security_public" {
  source        = "./modules/security"
  vpc_id        = data.aws_vpc.vpc-kuikvengers.id
  ingress_ports = [22, 80, 443]
  name          = "public-sg"
}

# Security Group privé
module "security_private" {
  source        = "./modules/security"
  vpc_id        = data.aws_vpc.vpc-kuikvengers.id
  ingress_ports = [22,80,443]
  name          = "private-sg"
}
# Création des instances EC2
locals {
  ami_list = [
    data.aws_ami.ubuntu_latest.id,
    data.aws_ami.amazon_linux_latest.id
  ]

  user_data_list = [
    <<-EOF
      #!/bin/bash
      apt update -y
      apt upgrade -y
      curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
      apt install -y nodejs
      npm install -g @angular/cli
    EOF,
    <<-EOF
      #!/bin/bash
      yum update -y
      amazon-linux-extras install nginx1 -y
      systemctl start nginx
      systemctl enable nginx
    EOF
  ]

  associate_public_ip_list = [true, false]
  subnet_list              = [module.subnet_public.subnet_id, module.subnet_private.subnet_id]
  sg_list                  = [module.security_public.security_group_id, module.security_private.security_group_id]
}

 
module "ec2" {
  source = "./modules/ec2"
  count  = 2
  
  ami_id              = local.ami_list[count.index]
  instance_type       = var.instance_type
  subnet_id           = local.subnet_list[count.index]
  security_group_id   = local.sg_list[count.index]
  key_name            = data.aws_key_pair.cle-kuikvengers-Mammar.key_name
  associate_public_ip = local.associate_public_ip_list[count.index]
  user_data           = local.user_data_list[count.index]
}