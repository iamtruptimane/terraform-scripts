#deploy whole vpc infrastrcture
terraform {
  backend "s3" {
    bucket = "terraform-backend-b5-bucket"
    region = "us-east-1"
    key = "terraform.tfstate"
  }
}
#defaine provider block
provider "aws" {
  region = var.region
}
#define resource block for vpc
resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    #if you call var in string
    Name = "${var.project}-vpc"
  }
} 
#define subnets
resource "aws_subnet" "pri_subnet" {
  #before generating id if you want to refer use attribute(output)
  vpc_id = aws_vpc.my_vpc.id 
  cidr_block = var.pri_sub_cidr
  availability_zone = var.az1
  tags = {
    Name = "${var.project}-private-subnet"
  }
}
resource "aws_subnet" "pub_subnet" {
  #before generating id if you want to refer use attribute(output)
  vpc_id = aws_vpc.my_vpc.id 
  cidr_block = var.pub_sub_cidr
  availability_zone = var.az2
  tags = {
    Name = "${var.project}-public-subnet"
  }
  map_public_ip_on_launch = true
}
resource "aws_internet_gateway" "my_igw" {
  #you don't need to specify any resource to attch vpc  
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "${var.project}-igw"
  }
}
#if you want to specify defalt resources which is getting created with other resource
#aws_route_table(create new RT) and aws_default_rout_table(modify existing RT)
resource "aws_default_route_table" "main_rt" {
  default_route_table_id = aws_vpc.my_vpc.default_route_table_id

  tags = {
    Name = "${var.project}.rt"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_default_route_table.main_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw.id
}

resource "aws_security_group" "sg1" {
  name = "${var.project}-sg1"
  vpc_id = aws_vpc.my_vpc.id
  description = "allow http port"

  ingress {
      protocol = "tcp"
      from_port = "80"
      to_port = "80"
      cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
      protocol = "tcp"
      from_port = "443"
      to_port = "443"
      cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol = "tcp"
    from_port = "22"
    to_port = "22"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  depends_on = [  
    aws_vpc.my_vpc
  ]
}
resource "aws_instance" "server1" {
  ami = var.image_id 
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_vpc.my_vpc.default_security_group_id, aws_security_group.sg1.id]
  subnet_id = aws_subnet.pri_subnet.id
  key_name =  var.key_pair 
  tags = {
    Name = "${var.project}-private-instance"
  }
  depends_on = [ 
    aws_security_group.sg1
   ]  
}
#copy paste and chnage
 
resource "aws_instance" "server2" {
  ami = var.image_id 
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_vpc.my_vpc.default_security_group_id, aws_security_group.sg1.id]
  subnet_id = aws_subnet.pub_subnet.id
  key_name =  var.key_pair 
  tags = {
    Name = "${var.project}-public-instance"
  }

  depends_on = [ 
    aws_security_group.sg1
   ]
}


