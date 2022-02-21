#----------------------------------------------------------
# Sample Jenkins Server (+webserver) during Bootstrap
#
# Made by Aliaksandr Traseuski
#----------------------------------------------------------


provider "aws" {
  region = "us-east-1"
}


resource "aws_instance" "jenkins_server" {
  ami                    = "ami-04505e74c0741db8d"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.jenkins_server.id]
  user_data              = <<EOF
#!/bin/bash
sudo apt update
sudo apt upgrade -y
sudo apt install -y apache2
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
sudo chmod -R 0777 /var/www/html
echo "<h2>WebServer with IP: $myip</h2><br>Build by Terraform!" > /var/www/html/index.html
sudo systemctl restart apache2
sudo apt install -y openjdk-11-jdk
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install -y jenkins
EOF

  tags = {
    Name  = "Jenkins Server Build by Terraform"
    Owner = "Aliaksandr Tratseuski"
  }
}


resource "aws_security_group" "jenkins_server" {
  name        = "WebServer Security Group"
  description = "My First SecurityGroup"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "Jenkins Server SecurityGroup"
    Owner = "selfstranger"
  }
}

output "instance_ip_addr" {
  description = "Public IP address of a new EC2 instance"
  value = aws_instance.jenkins_server.public_ip
}
