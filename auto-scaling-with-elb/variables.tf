variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}

variable "elb_port" {
  description = "The port the ELB will use for HTTP requests"
  type        = number
  default     = 80
}

variable "community_ami" {
  description = "AMI you want to use"
  type        = string
  default     = "ami-00399ec92321828f5"
}
variable "instace_type" {
  description = "Instance type you want to deploy"
  type        = string
  default     = "t3.micro"
}
variable "open-for-public" {
  description = "Web traffic open for Public against port 80 & 443"
  type        = any
  default     = ["0.0.0.0/0"]
}