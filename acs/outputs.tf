output "k8s_id" {
  value = "${azurerm_container_service.k8sexample.id}"
}

output "private_key_prem" {
  value = "${chomp(tls_private_key.ssh_key.private_key_pem)}"
}

output "acs_master_fqdn" {
  value = "${lookup(azurerm_container_service.k8sexample.master_profile[0], "fqdn")}"
}

output "acs_agent_pool_fqdn" {
  value = "${lookup(azurerm_container_service.k8sexample.agent_pool_profile[0], "fqdn")}"
}

output "acs_diagnostics_uri" {
  value = "${lookup(azurerm_container_service.k8sexample.diagnostics_profile[0], "storage_uri")}"
}

output "nginx_ip" {
  value = "${kubernetes_service.nginx.load_balancer_ingress.0.ip}"
}
