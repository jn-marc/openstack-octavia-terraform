variable "private-network" {
  type    = "string"
  default = "private"
}

variable "floating-ip-pool" {
  type    = "string"
  default = "internet"
}

variable "ssh-key-name" {
  type    = "string"
  default = "automation"
}

variable "whitelist_ips" {
  type = "list"

  default = [
    "IP1/32",
    "IP2/32",
  ]
}
