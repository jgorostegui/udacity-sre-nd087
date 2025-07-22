variable "name" {}
variable "vpc_id" {}
variable "public_subnet_ids" {}
variable "ec2_instance_ids" {
  type = list(string)
}
variable "tags" {
  default = {}
} 