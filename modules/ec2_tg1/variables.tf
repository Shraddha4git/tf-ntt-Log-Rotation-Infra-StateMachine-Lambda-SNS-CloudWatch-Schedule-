variable "ec2_security_group_id" {
    type = string
}
variable "private_subnet_ids" {
    type = list(string)
}
variable "public_subnet_ids" {
    type = list(string)
}
variable "tg1_arn" {
    type = string
}
variable "bastion-server-public_ip" {
  type = string
}