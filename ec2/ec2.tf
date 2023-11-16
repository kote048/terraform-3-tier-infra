resource "aws_instance" "web" {
 ami = var.ami
 instance_type = var.instance_type
 subnet_id = var.subnet1_id
 user_data = file("scripts/web-server-setup.sh")
 vpc_security_group_ids = [ aws_security_group.web_server_sg.id ]
 tags = {
   Name = var.instance_name
 }
}


resource "aws_security_group" "web_server_sg" {
  name        = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-web-sg"
  description = "Allow web traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "web port"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

  }
  ingress {
    description      = "secure web port"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]

  }
tags = merge(var.tags, {Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-web-sg"})


}
