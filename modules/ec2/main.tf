resource "aws_instance" "module_instance" {
    ami = var.ami
    instance_type = "t2.micro"
    subnet_id = var.subnets
    vpc_security_group_ids = var.vpc_sg
    associate_public_ip_address = true
    key_name = "DevOpsSheriff"
    user_data = var.launch_config

    tags = {
      Name = var.instance_name
    }
}