provider "google" {
  project = var.project_id
  region  = var.region
}

# VPC
resource "google_compute_network" "vpc" {
  name                    = sensitive("${var.name}-vpc")
  auto_create_subnetworks = "false"
}

# Subnet Privada
resource "google_compute_subnetwork" "subnet_priv1" {
  name          = sensitive("${var.project_id}-subnet-priv1")
  region        = var.region_vpc
  network       = google_compute_network.vpc.name
  ip_cidr_range = var.vpc_ip_cidr_range
  purpose       = "PRIVATE"
  secondary_ip_range {
    range_name    = var.cluster_secondary_range_name
    ip_cidr_range = var.cidr_cluster_secondary_range_name
  }
  secondary_ip_range {
    range_name    = var.services_secondary_range_name
    ip_cidr_range = var.cidr_services_secondary_range_name
  }
}
resource "google_compute_subnetwork" "subnet_priv2" {
  name          = sensitive("${var.project_id}-subnet-priv2")
  region        = var.region_vpc
  network       = google_compute_network.vpc.name
  ip_cidr_range = var.vpc_ip_cidr_range
  purpose       = "PRIVATE"
  secondary_ip_range {
    range_name    = var.cluster_secondary_range_name
    ip_cidr_range = var.cidr_cluster_secondary_range_name
  }
  secondary_ip_range {
    range_name    = var.services_secondary_range_name
    ip_cidr_range = var.cidr_services_secondary_range_name
  }
}
resource "google_compute_subnetwork" "subnet_priv3" {
  name          = sensitive("${var.project_id}-subnet--priv3")
  region        = var.region_vpc
  network       = google_compute_network.vpc.name
  ip_cidr_range = var.vpc_ip_cidr_range
  purpose       = "PRIVATE"
  secondary_ip_range {
    range_name    = var.cluster_secondary_range_name
    ip_cidr_range = var.cidr_cluster_secondary_range_name
  }
  secondary_ip_range {
    range_name    = var.services_secondary_range_name
    ip_cidr_range = var.cidr_services_secondary_range_name
  }
}
# Subnet Publica
resource "google_compute_subnetwork" "subnet_pub1" {
  name          = sensitive("${var.project_id}-subnet-priv1")
  region        = var.region_vpc
  network       = google_compute_network.vpc.name
  ip_cidr_range = var.vpc_ip_cidr_range
  purpose       = "PUBLIC"
  secondary_ip_range {
    range_name    = var.cluster_secondary_range_name
    ip_cidr_range = var.cidr_cluster_secondary_range_name
  }
  secondary_ip_range {
    range_name    = var.services_secondary_range_name
    ip_cidr_range = var.cidr_services_secondary_range_name
  }
}
resource "google_compute_subnetwork" "subnet_pub2" {
  name          = sensitive("${var.project_id}-subnet-priv2")
  region        = var.region_vpc
  network       = google_compute_network.vpc.name
  ip_cidr_range = var.vpc_ip_cidr_range
  purpose       = "PUBLIC"
  secondary_ip_range {
    range_name    = var.cluster_secondary_range_name
    ip_cidr_range = var.cidr_cluster_secondary_range_name
  }
  secondary_ip_range {
    range_name    = var.services_secondary_range_name
    ip_cidr_range = var.cidr_services_secondary_range_name
  }
}
resource "google_compute_subnetwork" "subnet_pub3" {
  name          = sensitive("${var.project_id}-subnet--priv3")
  region        = var.region_vpc
  network       = google_compute_network.vpc.name
  ip_cidr_range = var.vpc_ip_cidr_range
  purpose       = "PUBLIC"
  secondary_ip_range {
    range_name    = var.cluster_secondary_range_name
    ip_cidr_range = var.cidr_cluster_secondary_range_name
  }
  secondary_ip_range {
    range_name    = var.services_secondary_range_name
    ip_cidr_range = var.cidr_services_secondary_range_name
  }
}

#CloudNat
resource "google_compute_router" "router" {
  name    = var.name
  project = var.project_id
  region  = var.region_vpc
  network = google_compute_network.vpc.name
  #bgp {
  #  asn                = var.router_asn
  #  keepalive_interval = var.router_keepalive_interval
  #}
}

resource "google_compute_address" "address" {
  name   = "nat-${var.name}"
  region = var.region_vpc
}

resource "google_compute_router_nat" "cluster-cnat" {
  name                               = "nat-${var.name}"
  router                             = google_compute_router.router.name
  region                             = var.region_vpc
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = google_compute_address.address.*.self_link
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name = google_compute_subnetwork.subnet_pub1.self_link
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
  subnetwork {
    name = google_compute_subnetwork.subnet_pub2.self_link
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
  subnetwork {
    name = google_compute_subnetwork.subnet_pub3.self_link
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}

resource "google_compute_firewall" "public_firewall" {
  name    = "public-firewall"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["public"]
}

resource "google_compute_firewall" "private_firewall" {
  name    = "private-firewall"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_tags  = ["private"]
  target_tags  = ["private"]
}