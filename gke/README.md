# Kubernetes in Google Container Engine (GKE)
Terraform configuration for deploying Kubernetes in [GKE](https://cloud.google.com/container-engine/).

## Introduction
This Terraform configuration will deploy a Kubernetes cluster into Google's managed Kubernetes service, Google Container Engine (GKE). (The acronym GKE is used because GCE is used for Google Compute Engine, Google's IaaS service.) It will use various Google Cloud Provider resources to create an entire Kubernetes cluster in GKE.

## Deployment Prerequisites

1. Sign up for a free [Google Cloud Platform](https://cloud.google.com) account. But if you're a HashiCorp employee, you should login to the Google Cloud using your HashiCorp account.
1. Visit the [Container Engine page](https://console.cloud.google.com/projectselector/kubernetes?_ga=2.262292879.-2027610234.1509054055) in the Google Cloud Platform to enable the Google Container Engine API in your project.
1. Create or select a project.
1. Enable billing for your project if it is not already enabled.
1. Install and configure the Google [Cloud SDK](https://cloud.google.com/sdk). In addition to downloading and extracting it, be sure to run the `google-cloud-sdk/install.sh` script and restart your Terminal. Also run `gcloud init` and follow the prompts to initialize the SDK.
1. Follow these [instructions](https://www.terraform.io/docs/providers/google/index.html#authentication-json-file) to download an authentication JSON file for your project.
1. Copy your downloaded authentication JSON file to the terraform-gke directory of this project.  You can shorten the name if you want.
1. You should probably also run `gcloud config set compute/zone <zone>` and `gcloud config set project <project>` to set your default compute zone and project.
1. Install the Kubernetes CLI, kubectl, by running `gcloud components install kubectl`.
1. Create a copy of k8s.tfvars.example called k8s.tfvars and set correct values for gcp_project and gcp_auth_file_name.  You can also change the values for gcp_region and gcp_zone in k8s.tfvars if you want.


## Deployment Steps
Execute the following commands to deploy your Kubernetes cluster to GKE:

1. Run `cd terraform-gke` to change into the terraform-gke directory.
1. Run `terraform init` to initialize your terraform-gke configuration.
1. Run `terraform plan -var-file="k8s.tfvars"` to do a Terraform plan.
1. Run `terraform apply -var-file="k8s.tfvars"` to do a Terraform apply.
1. Run `gcloud container clusters get-credentials k8sexample-cluster` to download credentials for use with kubectl.
1. Test your connection with `kubectl get nodes`. You should see the number of nodes you specified with the initial_node_count variable. If not, try again after a few minutes.
1. After both your nodes are in the Ready state, run the following commands to deploy nginx to your Kubernetes cluster and expose it as a service:

    ```
    kubectl run nginx --image nginx
    kubectl expose deployments nginx --port=80 --type=LoadBalancer
    kubectl get service nginx --watch
    ```

1. The first should return 'deployment "nginx" created'. The second should return 'service "nginx" exposed'. The third should return nginx as a service. Initially, the external IP will be shown as \<pending\>, but after some time, you will see it switch to an actual IP address.  Use \<control\>-c when that happens.
1. Finally, enter the displayed external IP of the nginx service in your browser. You should see the "Welcome to nginx!" page.

## Cleanup
Execute the following command to delete your Kubernetes cluster and associated resources from GKE.

1. Run `kubectl delete service,deployment nginx` to delete the Kubernetes service and deployment.
1. Run `terraform destroy -var-file="k8s.tfvars"` to destroy the GKE cluster and other resources that were provisioned by Terraform.
