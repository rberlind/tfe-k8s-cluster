terraform {
  required_version = ">= 0.10.1"
}

provider "google" {
  project     = "${var.gcp_project}"
  region      = "${var.gcp_region}"
}

resource "google_container_cluster" "k8sexample" {
  name               = "${var.cluster_name}"
  description        = "example k8s cluster"
  zone               = "${var.gcp_zone}"
  initial_node_count = "${var.initial_node_count}"

  master_auth {
    username = "${var.master_username}"
    password = "${var.master_password}"
  }

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    machine_type = "${var.node_machine_type}"
    disk_size_gb = "${var.node_disk_size}"

  }
}

provider "kubernetes" {
  host = "${google_container_cluster.k8sexample.endpoint}"
  username = "${var.master_username}"
  password = "${var.master_password}"
  client_certificate = "${base64decode(google_container_cluster.k8sexample.master_auth.0.client_certificate)}"
  client_key = "${base64decode(google_container_cluster.k8sexample.master_auth.0.client_key)}"
  cluster_ca_certificate = "${base64decode(google_container_cluster.k8sexample.master_auth.0.cluster_ca_certificate)}"
}

resource "kubernetes_pod" "nginx" {
  metadata {
    name = "nginx"
    labels {
      App = "nginx"
    }
  }

  spec {
    container {
      image = "nginx:1.7.8"
      name  = "nginx"

      port {
        container_port = 80
      }
    }
  }
}

resource "kubernetes_service" "nginx" {
  metadata {
    name = "nginx"
  }
  spec {
    selector {
      App = "${kubernetes_pod.nginx.metadata.0.labels.App}"
    }
    port {
      port = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}
