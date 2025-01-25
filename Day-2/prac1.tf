#Deploy application in three diffrent region using provider and alias
# Configure AWS providers for three regions with aliases
provider "aws" {
  region = "us-east-1"
  alias  = "us_east"
}

provider "aws" {
  region = "us-west-1"
  alias  = "us_west"
}

# Deploy resources in the US East region
resource "aws_instance" "web_us_east" {
  provider = aws.us_east
  ami           = "ami-05576a079321f21f8"
  instance_type = "t2.micro"
  key_name      = "server-key"

  tags = {
    Name = "web-server-us-east"
  }
}

# Deploy resources in the US West region
resource "aws_instance" "web_us_west" {
  provider = aws.us_west
  ami           = "ami-004374a3d56f732a6"
  instance_type = "t2.micro"
  key_name      = "california-key"

  tags = {
    Name = "web-server-us-west"
  }
}

