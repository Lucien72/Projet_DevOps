terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.35"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "us-east-2"
  //aws_credencials_file = "~/aws/credentials-ynov"
}

resource "aws_key_pair" "ssh_key" {
  key_name = var.key_name
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCxwdvsyOpBvKc72N3rt980XxQdf6A7pkOma+NT0SA/0JzfETo9DY/p9BzfO6+rghS2Luke40yY0qQna8Rs6o/fWWl033gqEOYaGXNBd4LU9kwZ8AxO7YHdmLRV/3QbGReVcf5Qj5utirJSbPQL57zddSGCjldljuf5BTnY+D05taXyMG59rnKeMgQPEa/Cx2Lm7bUjDhOkZB+dFfR7f8aLoebuN/GSQZGvzcXmRxBy8zBEpAlpsKNmqpRDTK4TQt+0pSc3Ylz6fCU+kyNE6D7Tgh1+/OQugPMF6dmSqB+BlSBPSjH6y7XvKQiSTImvTKfHlvNxOMnsW4MF0BP81QZDMOJz0SKMvT3s1Ew161HpZkDTWpf4+l+DmwQMKIlSGkoyycOQxzNj8LqAKiJE93bTPkYrs4B8CebOpJJ12hsyavBHYU4L3IRPVJntEN8PQ8vrC+n+w+NE02hDToWpARnT5f4wux+yMd/Djt1m3A4Sm3JorgDMIi/GuPsPUA1vbpk= lucien.richer@icloud.com"
}

resource "aws_security_group" "allow_ssh_Richer" {
  name        = "allow_ssh_Richer"
  description = "Allow SSH inbound traffic"

  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh_Richer"
  }
}

resource "aws_instance" "app_server" {
  ami           = "ami-0d97ef13c06b05a19"
  instance_type = "t2.micro"

  key_name = var.key_name
  associate_public_ip_address = "true"
  vpc_security_group_ids = [aws_security_group.allow_ssh_Richer.id, aws_security_group.allow_httpd_Richer.id]
  

  tags = {
    Name   = "var.instance_name"
    Groups = "app"
    Owner  = "Richer-Lucien"
  }
}

resource "aws_security_group" "allow_httpd_Richer" {
  name        = "allow_httpd_Richer"
  description = "Allow HTTPD inbound traffic"

  ingress {
    description      = "HTTPD from VPC"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_httpd_Richer"
  }
}