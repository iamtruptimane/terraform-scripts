#define all variable needed to deploy 
variable "region" {
  default = "us-east-1"
}
variable "az1" {
  default = "us-east-1b"
}
variable "az2" {
  default = "us-east-1a"
}
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "pri_sub_cidr" {
  default = "10.0.0.0/20"
}

variable "project" {
  default = "IEC"
}
variable "pub_sub_cidr" {
  default = "10.0.16.0/20"
}

variable "image_id" {
  default = "ami-05576a079321f21f8"
}
variable "instance_type" {
  default = "t2.micro"
}
variable "key_pair" {
  default = "server-key"
}