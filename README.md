# Kubernetes
Terraform configurations to deploy Kubernetes clusters in various clouds

## Introduction
Kubernetes can be deployed in many ways as indicated in the Kubernetes [Picking the Right Solution](https://kubernetes.io/docs/setup/pick-right-solution/) documentation. We've taken the approach in this guide of providing Terraform configurations for Kubernetes deployment options that we think customers are most likely to use.

Since Azure and Google Cloud Platform (GCP) offer Kubernetes managed services, we think customers will prefer to leverage those managed services in those clouds since they make Kubernetes deployments easier and can cost less. So, for Azure and GCP we use the corresponding container service resources which provision complete Kubernetes clusters including the underlying VMs, networks, and other required constructs.

Since AWS does not provide a managed Kubernetes solution, we will provide a Terraform configuration for AWS that explicitly provisions the underlying VMs, networks, and other AWS constructs.

Note that this configuration only provisions the Kubernetes clusters. A separate configuration will be used to provision Kubernetes pods and services with Terraform's Kubernetes Provider.
