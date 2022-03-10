variable "cidr" {
  description = "Direccion IP privados a utilizar VPC de AWS"
  default = "10.0.0.0/20"
}

variable "ssh_pub_path" {
  description = "Direccion de las llabes ssh publica"
  default = "~/.ssh/id_rsa.pub"
}
