#configure aws provider block
provider "aws" {
  region = "us-east-1"
  access_key = "<YOUR-ACCESS-KEY>"
  secret_key = "<YOUR-SECRET-KEY>"
}
#configure aws resource block
resource "aws_instance" "web" {
    ami = "ami-05576a079321f21f8"
    instance_type = "t3.micro"
    key_name = "server-key"
    tags = {
        Name = "web-server"
    } 
}