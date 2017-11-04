# Kubernetes in Legacy Azure Container Service (ACS)
Terraform configuration for deploying Kubernetes in the [legacy Azure Container Service (ACS)](https://docs.microsoft.com/en-us/azure/container-service/kubernetes/).

## Introduction
This Terraform configuration replicates what an Azure customer could do with the `az acs create` [CLI command](https://docs.microsoft.com/en-us/cli/azure/acs?view=azure-cli-latest#az_acs_create). It uses the Microsoft AzureRM provider's azurerm_container_service resource to create an entire Kubernetes cluster in ACS including required VMs, networks, and other Azure constructs. Note that this creates a legacy ACS service which includes both the master node VMs that run the Kubernetes control plane and the agent node VMs onto which customers deploy their containerized applications. This differs from the  [new Azure Container Service (AKS)](https://docs.microsoft.com/en-us/azure/aks/) which excludes the master node VMs since Microsoft runs those outside the customer's Azure account.

## Deployment Prerequisites

1. Sign up for a free [Azure account](https://azure.microsoft.com/en-us/free/).
1. Install [Azure CLI 2.0](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
1. Configure the Azure CLI for your account and generate a Service Principal for Kubernetes to use when interacting with the Azure Resource Manager. See these [instructions](https://www.terraform.io/docs/providers/azurerm/authenticating_via_service_principal.html). If you only have a single subscription in your Azure account, this just involves running `az login` and following the prompts, running `az account list`, and running `az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/<SUBSCRIPTION_ID>"` where \<SUBSCRIPTION_ID\> is the id returned by the `az account list` command.
1. Create a copy of k8s.tfvars.example called k8s.tfvars and set azure_client_id and azure_client_secret to the service principal's appID and password respectively. Set azure_subscription_id in k8s.tfvars to your subscription ID and set azure_tenant_id to the tenant of your service principal.
1. Set dns_master_prefix and dns_agent_pool_prefix in k8s.tfvars to strings that you would like Azure to use as the DNS prefixes for the master and agent nodes in your Kubernetes cluster.  
1. Install the [Kubernetes CLI](https://kubernetes.io/docs/tasks/tools/install-kubectl/). As an alternative to downloading kubectl with curl, you could use the command `az acs kubernetes install-cli` and let the Azure CLI install it for you.
1. If kubectl cannot be found when you try to invoke it, add it to a directory in your path or to your $PATH environment variable in your .bash_profile or create a symlink pointing to it as shown above for acs-engine.

## Deployment Steps
Execute the following commands to deploy your Kubernetes cluster to ACS.

1. Run `cd terraform-acs` to change into the terraform-acs-engine directory.
1. Run `terraform init` to initialize your terraform-acs-engine configuration.
1. Run `terraform plan -var-file="k8s.tfvars"` to do a Terraform plan.
1. Run `terraform apply -var-file="k8s.tfvars"` to do a Terraform apply.
1. Run `scp -i <SSH-KEY> azureuser@<MASTER-PUBLIC-IP>:~/.kube/config ~/.kube/config`, replacing \<SSH_KEY\> with your private key file and \<MASTER-PUBLIC-IP\> with the IP of the public IP address created for your master node in your Azure resource group. This will copy your Kubernetes cluster's configuration to your laptop, enabling you to connect to your cluster with kubectl.
1. Test your connection with `kubectl get nodes`. You should see 1 master node and 1 agent node. If not, try again after a few minutes.
1. After both your master and agent nodes are in the Ready state, run the following commands to deploy nginx to your Kubernetes cluster and expose it as a service:

    ```
    kubectl run nginx --image nginx
    kubectl expose deployments nginx --port=80 --type=LoadBalancer
    kubectl get service nginx --watch
    ```

1. The first should return 'deployment "nginx" created'. The second should return 'service "nginx" exposed'. The third should return nginx as a service. Initially, the external IP will be shown as \<pending\>, but after some time, you will see it switch to an actual IP address.  Use \<control\>-c when that happens.
1. Finally, enter the displayed external IP of the nginx service in your browser. You should see the "Welcome to nginx!" page.

## Cleanup
Execute the following command to delete your Kubernetes cluster and associated resources from ACS.

1. Run `kubectl delete service,deployment nginx` to delete the Kubernetes service and deployment.
1. Run `terraform destroy -var-file="k8s.tfvars"` to destroy the ACS cluster and other resources that were provisioned by Terraform.
