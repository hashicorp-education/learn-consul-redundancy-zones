output "consul_token" {
  sensitive = true
  value = random_uuid.consul_bootstrap_token.result
  description = "Consul bootstrap token"
}

output "consul_group1_ips" {
  value = concat(aws_instance.consul-server-group1[*].public_ip)
  description = "Public IP of the first group of Consul Servers"
}

output "consul_group2_ips" {
  value = concat(aws_instance.consul-server-group2[*].public_ip)
  description = "Public IPs of the second group of Consul Servers"
}

output "next_steps" {
  value = [
  "You can now add the TLS certificate for accessing your EC2 instances by running:",
  "ssh-add ${local_file.key_instances_key.filename}",
  ]
}