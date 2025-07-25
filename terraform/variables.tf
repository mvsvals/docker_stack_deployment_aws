variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "region" {
  description = "AWS Region"
  type        = string
}

variable "web_instance_count" {
  description = "Number of Web instances"
  type        = number
}

variable "ami" {
  description = "AMI to be deployed"
  type        = string
}

variable "maintenance_ip" {
  description = "The IP used for SSH maintenance"
  type        = string
}
