variable "cluster_id" {
  type        = string
  description = "The name of your Consul cluster"
  default     = "learn-consul-redundancy"
}

variable "datacenter" {
  type = string
  description = "Name of the Consul datacenter"
  default = "dc1"
}

variable "aws_region" {
  type        = string
  description = "The AWS region to create resources in"
  default     = "us-east-2"
}

variable "consul_version" {
  type        = string
  description = "The HCP Consul version"
  default     = "v1.17.3+ent"
}
