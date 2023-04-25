output "instance_public_ip" {
    value = aws_instance.module_instance.public_ip
}