# Exemple minimal de provisionnement avec Terraform (à adapter)
provider "aws" {
  region = "eu-west-1"
}

resource "aws_instance" "master" {
  ami           = var.ami_id
  instance_type = var.instance_type
  tags = {
    Name = "k8s-master"
  }
}

resource "aws_instance" "worker" {
  count         = 2
  ami           = var.ami_id
  instance_type = var.instance_type
  tags = {
    Name = "k8s-worker-\${count.index + 1}"
  }
}
