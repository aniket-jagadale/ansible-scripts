provider "aws" {
  region = "us-east-1"
}
resource "aws_instance" "myservers" {
    
    ami           = "ami-068c0051b15cdb816" # Amazon Linux 2 AMI
    instance_type = "t2.micro"
    key_name    = "ansiblekey"
    for_each = toset(["appserver", "dbserver"])
    security_groups = [aws_security_group.my-sg.id]
    tags = {
        Name = each.key
    }
}
resource "aws_instance" "myservers" {
    ami           = "ami-068c0051b15cdb816" # Amazon Linux 2 AMI
    instance_type = "t2.micro"
    key_name    = "ansiblekey"
    security_groups = [aws_security_group.my-sg.id]
    tags = {
        Name = "ansible-server"
    }
    user_data = <<-EOF
                #!/bin/bash
                sudo -i
                yum update -y
                yum install -y ansible
                cd /etc/ansible
                mkdir playbooks
                cd playbooks
                EOF
}
resource "aws_security_group" "my-sg" {
    name        = "my-security-group"
    description = "Allow SSH and HTTP traffic"
    
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
