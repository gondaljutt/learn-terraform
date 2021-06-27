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
variable "server_http_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 80
}
variable "server_https_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 443
}
variable "ssh_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 22
}
variable "open-for-public" {
  description = "Web traffic open for Public against port 80 & 443"
  type        = any
  default     = ["0.0.0.0/0"]
}
variable "close-for-public" {
  description = "Web traffic close for Public against port 22 etc"
  type        = any
  default     = ["72.255.7.47/32", "72.255.7.48/32"]
}