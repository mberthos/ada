terraform {
  backend "remote" {
    organization = "Mottu"
    workspaces {
      prefix = "mottu-gke-"
    }
  }
}

# Cluster GKE
resource "google_container_cluster" "mottu_dev_cluster" {
  name     = var.name
  location = var.region
  remove_default_node_pool = true
  initial_node_count       = var.gke_num_nodes_app
  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet_priv1.name

  ip_allocation_policy {
    cluster_secondary_range_name  = var.cluster_secondary_range_name
    services_secondary_range_name = var.services_secondary_range_name
  }

  private_cluster_config {
    enable_private_endpoint = false
    enable_private_nodes = true
    master_ipv4_cidr_block = var.private_cluster_config_master_ipv4_cidr_block
  }
  master_authorized_networks_config {
    #count = length(var.master_authorized_networks_config)
    cidr_blocks {
      #count = length(var.master_authorized_networks_config)
      cidr_block = var.master_authorized_networks_config #[count.index]
    }
  }
  # only one of logging/monitoring_service or logging/monitoring_config can be specified
  dynamic "logging_config" {
    for_each = length(var.logging_enabled_components) > 0 ? [1] : []
    content {
      enable_components = var.logging_enabled_components
    }
  }
  lifecycle {
    prevent_destroy = true
  }
}

# Node Pool Gerenciado Separadamente App
resource "google_container_node_pool" "nodes_mottu_app" {
  name       = "${google_container_cluster.mottu_dev_cluster.name}-mottuapp-nodepool"
  location   = var.region
  cluster    = google_container_cluster.mottu_dev_cluster.name
  node_count = var.gke_num_nodes_app
  autoscaling{
    min_node_count = var.gke_autoscaling_nodes_min
    max_node_count = var.gke_autoscaling_nodes_max
  }

  node_config {
    machine_type = var.machine_type_mottuapp
    preemptible  = var.preemptible
    disk_size_gb = 50
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/trace.append"
    ]
    labels = {
      env = sensitive(var.project_id)
    }
    tags         = ["gke-node", sensitive("${var.project_id}-gke")]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}