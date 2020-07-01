variable "region" {
  type        = string
  description = "AWS region to create the server in"
  default     = "us-west-2"
}
variable "name" {
  type        = string
  description = "Name of the server. Will be used to name AWS resources and for tagging."
  default     = "acc-server"
}

variable "admin_key_pair_name" {
  type        = string
  description = "EC2 keypair to use for server access (must be pre-created)"
}

variable "instance_type" {
  type        = string
  description = "Size of the EC2 instance for the server. Larger for more slots."
  default     = "t2.small"
}

variable "acc_server_zip_file" {
  type        = string
  description = "The zipped contents of the server/ directroy from ACC. This should not contain the server/ directroy, but it's contents at the root."
}
