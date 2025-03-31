variable "ami_id" {
  description = "AMI ID pour les instances"
}

variable "instance_type" {
  description = "Type d'instance"
  default     = "t2.micro"
}
