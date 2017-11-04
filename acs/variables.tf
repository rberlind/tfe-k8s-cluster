variable "private_key_filename" {
  default     = "private_key.pem"
  description = "Name of the SSH private key in PEM format"
}

variable "public_key_openssh_filename" {
  default     = "public_key_openssh"
  description = "Name of the SSH public key in OpenSSH format"
}

variable "azure_subscription_id" {
  description = "Azure Subscription ID"
}

variable "azure_tenant_id" {
  description = "Azure Tenant ID"
}

variable "azure_client_id" {
  description = "Azure Client ID"
}

variable "azure_client_secret" {
  description = "Azure Client Secret"
}

variable "dns_master_prefix" {
  description = "DNS prefix for the master nodes of your cluster"
}

variable "dns_agent_pool_prefix" {
  description = "DNS prefix for the agent nodes of your cluster"
}

variable "azure_location" {
  description = "Azure Location, e.g. North Europe"
  default = "East US"
}

variable "resource_group_name" {
  description = "Azure Resource Group Name"
  default = "k8sexample-acs"
}

variable "master_vm_count" {
  description = "Number of master VMs to create"
  default = 1
}

variable "vm_size" {
  description = "Azure VM type"
  default = "Standard_A2"
}

variable "worker_vm_count" {
  description = "Number of worker VMs to initially create"
  default = 1
}

variable "admin_user" {
  description = "Administrative username for the VMs"
  default = "azureuser"
}

variable "cluster_name" {
  description = "Name of the K8s cluster"
  default = "k8sexample-cluster"
}

variable "agent_pool_name" {
  description = "Name of the K8s agent pool"
  default = "default"
}

variable "diagnostics_enabled" {
  description = "Boolean indicating whether to enable VM diagnostics"
  default = "false"
}

variable "environment" {
  description = "value passed to ACS Environment tag"
  default = "dev"
}
