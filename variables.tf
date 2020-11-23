variable vpc_cidr_block {
  type        = string
  description = "vpc cidr_block"
  default     = "10.2.0.0/16"
}

variable environment_name {
  type        = string
  description = "the name of an environment"
  default     = "acme-dev"
}

variable ingress_cidr_blocks {
  type        = list(string)
  description = "list of cidr blocks to allow incoming traffic"
  default     = ["67.169.175.5/32", "10.2.1.0/24"]
}

variable egress_cidr_blocks {
  type        = list(string)
  description = "list of cidr blocks to allow outgoing traffic"
  default     = ["0.0.0.0/0"]
}

variable instance_type {
  type        = string
  description = "the type of ec2 instance"
  default     = "t2.micro"
}

variable backend_instance_count {
  type        = number
  description = "the count of backend ec2 instances"
  default     = 3
}