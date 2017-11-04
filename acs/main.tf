terraform {
  required_version = ">= 0.10.1"
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
}

provider "azurerm" {
  subscription_id = "${var.azure_subscription_id}"
  tenant_id       = "${var.azure_tenant_id}"
  client_id       = "${var.azure_client_id}"
  client_secret   = "${var.azure_client_secret}"
}

# Azure Resource Group
resource "azurerm_resource_group" "k8sexample" {
  name     = "${var.resource_group_name}"
  location = "${var.azure_location}"
}

# Azure Container Service with Kubernetes orchestrator
resource "azurerm_container_service" "k8sexample" {
  name                   = "${var.cluster_name}"
  location               = "${azurerm_resource_group.k8sexample.location}"
  resource_group_name    = "${azurerm_resource_group.k8sexample.name}"
  orchestration_platform = "Kubernetes"

  master_profile {
    count      =  "${var.master_vm_count}"
    dns_prefix = "${var.dns_master_prefix}"
  }

  linux_profile {
    admin_username = "${var.admin_user}"
    ssh_key {
      key_data = "${chomp(tls_private_key.ssh_key.public_key_openssh)}"
    }
  }

  agent_pool_profile {
    name       = "${var.agent_pool_name}"
    count      =  "${var.worker_vm_count}"
    dns_prefix = "${var.dns_agent_pool_prefix}"
    vm_size    = "${var.vm_size}"
  }

  service_principal {
    client_id     = "${var.azure_client_id}"
    client_secret = "${var.azure_client_secret}"
  }

  diagnostics_profile {
    enabled = "${var.diagnostics_enabled}"
  }

  tags {
    Environment = "${var.environment}"
  }
}
