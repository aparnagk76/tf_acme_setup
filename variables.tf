variable key_name {
  type        = string
  description = "the name of a key"
  default     = "aparna1"
}

variable "private_key_path" {
  type        = string
  description = "the path of a private key"
  default     = "~/.ssh/aparna1.pem"
}
