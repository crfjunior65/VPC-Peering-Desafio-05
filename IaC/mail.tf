# providers.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}

provider "aws" {
  alias  = "sao_paulo"
  region = "sa-east-1"
}

# vpc.tf
module "vpc_virginia" {
  providers = { aws = aws.virginia }
  source    = "terraform-aws-modules/vpc/aws"
  version   = "~> 5.0"

  name = "vpc-virginia"
  cidr = "10.12.0.0/16"
  azs  = ["us-east-1a"]

  public_subnets  = ["10.12.1.0/24"]
  private_subnets = ["10.12.2.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
}

module "vpc_sao_paulo" {
  providers = { aws = aws.sao_paulo }
  source    = "terraform-aws-modules/vpc/aws"
  version   = "~> 5.0"

  name = "vpc-sao-paulo"
  cidr = "10.11.0.0/16"
  azs  = ["sa-east-1a"]

  public_subnets  = ["10.11.1.0/24"]
  private_subnets = ["10.11.2.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
}

# peering.tf
resource "aws_vpc_peering_connection" "virginia_to_saopaulo" {
  provider    = aws.virginia
  vpc_id      = module.vpc_virginia.vpc_id
  peer_vpc_id = module.vpc_sao_paulo.vpc_id
  peer_region = "sa-east-1"
  auto_accept = false

  tags = {
    Name = "peering-virginia-saopaulo"
  }
}

resource "aws_vpc_peering_connection_accepter" "saopaulo_accepter" {
  provider                  = aws.sao_paulo
  vpc_peering_connection_id = aws_vpc_peering_connection.virginia_to_saopaulo.id
  auto_accept               = true

  tags = {
    Name = "accepter-saopaulo"
  }
}

# routes.tf (rotas para o peering)
resource "aws_route" "virginia_public_route" {
  provider                  = aws.virginia
  route_table_id            = module.vpc_virginia.public_route_table_ids[0]
  destination_cidr_block    = "10.11.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.virginia_to_saopaulo.id
}

resource "aws_route" "sao_paulo_public_route" {
  provider                  = aws.sao_paulo
  route_table_id            = module.vpc_sao_paulo.public_route_table_ids[0]
  destination_cidr_block    = "10.12.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.virginia_to_saopaulo.id
}

# security_groups.tf
resource "aws_security_group" "virginia_sg" {
  provider    = aws.virginia
  name_prefix = "virginia-sg-"
  vpc_id      = module.vpc_virginia.vpc_id

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "sao_paulo_sg" {
  provider    = aws.sao_paulo
  name_prefix = "sao-paulo-sg-"
  vpc_id      = module.vpc_sao_paulo.vpc_id

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ec2.tf
data "aws_ami" "amazon_linux_virginia" {
  provider    = aws.virginia
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

data "aws_ami" "amazon_linux_sao_paulo" {
  provider    = aws.sao_paulo
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "virginia_ec2" {
  provider                    = aws.virginia
  ami                         = data.aws_ami.amazon_linux_virginia.id
  instance_type               = "t3.micro"
  subnet_id                   = module.vpc_virginia.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.virginia_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "ec2-virginia"
  }
}

resource "aws_instance" "sao_paulo_ec2" {
  provider                    = aws.sao_paulo
  ami                         = data.aws_ami.amazon_linux_sao_paulo.id
  instance_type               = "t3.micro"
  subnet_id                   = module.vpc_sao_paulo.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.sao_paulo_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "ec2-sao-paulo"
  }
}

# outputs.tf
output "virginia_ec2_public_ip" {
  value = aws_instance.virginia_ec2.public_ip
}

output "sao_paulo_ec2_public_ip" {
  value = aws_instance.sao_paulo_ec2.public_ip
}