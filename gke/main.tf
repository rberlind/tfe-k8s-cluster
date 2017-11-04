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
