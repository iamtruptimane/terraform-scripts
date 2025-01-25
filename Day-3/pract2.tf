#explore output block
terraform {
  backend "s3" {
    bucket = "terraform-backend-b4-bucket"
    region = "us-east-2"
    key = "terraform.tfstate" 
  }
}
#manage pre-existing resources through terraform
data "aws_security_group" "my-sg" {
    filter {
      name = "vpc-id"
      values = ["vpc-0cbbdb15bbcd7d653"]
    }
    filter {
      name = "group-name"
      values = [ "web-sg" ]
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
    #refere data resource like this
    vpc_security_group_ids = [data.aws_security_group.my-sg.id] 
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

#Define output-> print data on display
output "demo" {
  value = "hello world"
}
#print public ip of instance
output "" {
  #refere resource block like this  
  value = aws_instance.web.public_ip
}
