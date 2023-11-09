

variable "tags" {
  type = map(string)
}

variable "private_subnet1" {
  description = "ID for the private subnet 1"
  type        = string
}

variable "private_subnet2" {
  description = "ID for the private subnet 2"
  type        = string
}

variable "vpc_id" {
  description = "vpc id"
  type        = string
}

variable "vpc_cidr_block" {
  description = "cidr block"
  type        = string
}