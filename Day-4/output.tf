#as soon as instance get launch i want to print public ip of instnace
output "public_ip" {
  value = aws_instance.server2.public_ip
}