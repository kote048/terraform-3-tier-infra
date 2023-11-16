variable "ami" {
  type = string
  description = "ami"
  default = "ami-070c8ca4ac77fae0b"
}

variable "instance_type" {
  type = string
  description = "ec2 type"
  default = "t2.micro"
}

variable "instance_name" {
  type = string
  description = "ec2 name"
  default = "amazon-instance"
}

variable "subnet1_id" {
  type = string
  description = "subnet id to be launching the ec2"
}

variable "vpc_id" {
  description = "vpc id"
  type        = string
}
variable "tags" {
  type = map(string)
}