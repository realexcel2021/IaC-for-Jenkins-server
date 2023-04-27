module "Production-server" {
    source = "./modules/ec2"
    instance_name = "Production-server"
    launch_config = file("config.sh")
    security_group = [ "jenkins-sg" ]
    ami = "ami-007855ac798b5175e"
    subnets = aws_subnet.jenkins_subnet.id
    vpc_sg = [ aws_security_group.sg-rules.id ]
}