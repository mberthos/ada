# Algumas variáveis extras
variable "gke_username" {
  default     = ""
  description = "user do gke"
}

variable "gke_password" {
  default     = ""
  description = "password do gke"
}
variable "taint" {
  description = "taint"
}

#vpc
variable "project_id" {
  description = "project id"
}

variable "region" {
  description = "region"
}

variable "name" {
  description = "name"
}


variable "gke_num_nodes_app" {
  default     = 1
  description = "numero de nodes para o cluster"
}

variable "gke_num_nodes_loki" {
  default     = 1
  description = "numero de nodes para o cluster"
}

variable "master_authorized_networks_config" {
  description = "master_authorized_networks_config"
  #type        = list(string)
  #default     = []
}

variable "private_cluster_config_master_ipv4_cidr_block" {
  description = "private_cluster_config_master_ipv4_cidr_block"
}

variable "vpc_ip_cidr_range" {
  description = "vpc_ip_cidr_range"
}

variable "region_vpc" {
  description = "region_vpc"
}

variable "cluster_secondary_range_name" {
  description = "The _name_ of the secondary subnet ip range to use for pods"
}

variable "cidr_cluster_secondary_range_name" {
  description = "The _name_ of the secondary subnet ip range to use for pods"
}

variable "services_secondary_range_name" {
  description = "The _name_ of the secondary subnet range to use for services"
}

variable "cidr_services_secondary_range_name" {
  description = "The _name_ of the secondary subnet range to use for services"
}

variable "logging_enabled_components" {
  type        = list(string)
  description = "List of services to monitor: SYSTEM_COMPONENTS, WORKLOADS. Empty list is default GKE configuration."
  default     = []
}

##nodepool

variable "gke_name" {
  default     = ""
  description = "user do gke"
}

variable "gke_autoscaling_nodes_min" {
  description = "gke_autoscaling_nodes_min"
}

variable "machine_type_mottuapp" {
  description = " "
}

variable "preemptible" {
  description = " "
}

variable "gke_autoscaling_nodes_max" {
  description = "gke_autoscaling_nodes_max"
}



