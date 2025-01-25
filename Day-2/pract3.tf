#explore terraform backend
terraform {
  backend "s3" {
    bucket = "terraform-backend-b4-bucket"
    region = "us-east-2"
    key = "terraform.tfstate" 
  }
}

provider "aws" {
    #should not quote var.region
    region = var.region
}

#configure aws resource block
resource "aws_instance" "web" {
    ami = "ami-05576a079321f21f8"
    instance_type = var.instance_type
    key_name = var.key_name
    tags = {
        Name = "web-server"
    } 
}

variable "region" {
    description = "please enter region"
    type = string
}

variable "instance_type" {
    description = "enter instance type"
    default = "t2.micro"  
}

variable "key_name" {
    default = "server-key"   
}

