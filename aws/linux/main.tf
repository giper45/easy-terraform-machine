provider "aws" {
  region = var.aws_region  # Update this to your desired AWS region
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = var.ssh_public_key
}
resource "aws_security_group" "terraform" {
  name        = "allow-ssh-http-https"
  description = "Allow SSH, HTTP, and HTTPS access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH from anywhere (for demo purposes)
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP from anywhere (for demo purposes)
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTPS from anywhere (for demo purposes)
  }
   egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow all outbound traffic to the internet
  }
}


resource "aws_instance" "terraform-machine" {
  ami           = var.aws_ami  # Ubuntu 22.04 LTS
  instance_type = "t2.micro"  # You can choose a different instance type

  key_name      =  aws_key_pair.deployer.key_name 

  tags = {
    Name = "terraform-machine"
  }

  # You may specify additional configurations, such as security groups and user data, as needed.
  security_groups = [aws_security_group.terraform.name]



}

output "hello" {
  value = <<HELLO
  Hello, to login: 
      ssh ec2-user@${aws_instance.terraform-machine.public_ip} # for Amazon AMIs
      ssh ubuntu@${aws_instance.terraform-machine.public_ip} # for Ubuntu AMIs
  HELLO
}
