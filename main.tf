provider "aws" {
    region = "us-east-1"
}

resource "aws_vpc" "jenkins_vpc" {
    cidr_block = "10.0.0.0/16"

    tags = {
        Name = "Jenkins-Servers_VPC"
    }
}

resource "aws_subnet" "jenkins_subnet" {
    vpc_id = aws_vpc.jenkins_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true

    tags = {
      Name = "jenkins_subnet"
    }
}

resource "aws_internet_gateway" "server_to_internet" {
    vpc_id = aws_vpc.jenkins_vpc.id
    tags = {
        Name = "Jenkins_internet"
    }
}

resource "aws_route_table" "jenkins_route_table" {
    vpc_id = aws_vpc.jenkins_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.server_to_internet.id
    }
    tags = {
        Name = "jenkins-route-table"
    }
}

resource "aws_route_table_association" "route_table_accociation" {
    subnet_id = aws_subnet.jenkins_subnet.id
    route_table_id = aws_route_table.jenkins_route_table.id
}

resource "aws_security_group" "sg-rules" {
    name = "jenkins-sg"
    vpc_id = aws_vpc.jenkins_vpc.id

    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 8000
        to_port = 8000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
    description = "SSH from the internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"          # Allow all protocols
    cidr_blocks = ["0.0.0.0/0"] # Allow to any IP address
  }
}

