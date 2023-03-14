# Algumas variáveis extras
variable "gke_username" {
  default     = "admin"
  description = "user do gke"
}

variable "gke_password" {
  default     = "123456"
  description = "password do gke"
}
variable "taint" {
  default = " "
  description = "taint"
}

#vpc
variable "project_id" {
  default = "nome-projeto-gcp"
  description = "project id"
}

variable "region" {
  default = "us-central-1"
  description = "region"
}

variable "name" {
  default = "ada-gke-poc"
  description = "name"
}


variable "gke_num_nodes_app" {
  default     = 1
  description = "numero de nodes para o cluster"
}

variable "master_authorized_networks_config" {
  description = "master_authorized_networks_config"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "private_cluster_config_master_ipv4_cidr_block" {
  default     = ["10.123.144.0/28"]
  description = "private_cluster_config_master_ipv4_cidr_block"
}

#subnets
variable "vpc_ip_cidr_range|_priv1" {
  default = "10.123.0.0/24"
  description = "vpc_ip_cidr_range"
}
variable "vpc_ip_cidr_range|_priv2" {
  default = "10.123.1.0/24"
  description = "vpc_ip_cidr_range"
}
variable "vpc_ip_cidr_range|_priv3" {
  default = "10.123.2.0/24"
  description = "vpc_ip_cidr_range"
}
variable "vpc_ip_cidr_range|_pub1" {
  default = "10.123.3.0/24"
  description = "vpc_ip_cidr_range"
}
variable "vpc_ip_cidr_range|_pub2" {
  default = "10.123.4.0/24"
  description = "vpc_ip_cidr_range"
}
variable "vpc_ip_cidr_range|_pub3" {
  default = "10.123.5.0/24"
  description = "vpc_ip_cidr_range"
}



variable "region_vpc" {
  default = "us-central1"
  description = "region_vpc"
}

variable "cluster_secondary_range_name" {
  default = "gke-ada-gke-ada-cluster-08910f31"
  description = "The _name_ of the secondary subnet ip range to use for pods"
}

variable "cidr_cluster_secondary_range_name" {
  default = ["10.124.0.0/22"]  #1022 Ips
  description = "The _name_ of the secondary subnet ip range to use for pods"
}

variable "services_secondary_range_name" {
  default = "gke-ada-gke-service-services-08910f31"
  description = "The _name_ of the secondary subnet range to use for services"
}

variable "cidr_services_secondary_range_name" {
  default = ["10.124.64.0/22"]  #1022 Ips
  description = "The _name_ of the secondary subnet range to use for services"
}

variable "logging_enabled_components" {
  type        = list(string)
  description = "List of services to monitor: SYSTEM_COMPONENTS, WORKLOADS. Empty list is default GKE configuration."
  default     = [ "SYSTEM_COMPONENTS" ]
}

##nodepool

variable "gke_name" {
  default     = ""
  description = "user do gke"
}

variable "gke_autoscaling_nodes_min" {
  default = 1
  description = "gke_autoscaling_nodes_min"
}

variable "machine_type_mottuapp" {
  default = "e2-standard-4"
  description = " "
}

variable "preemptible" {
  default = "true"
  description = " "
}

variable "gke_autoscaling_nodes_max" {
  default = 3
  description = "gke_autoscaling_nodes_max"
}



