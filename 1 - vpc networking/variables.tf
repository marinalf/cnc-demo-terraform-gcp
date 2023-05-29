
# CNC Credentials & GCP Project

variable "username" {}
variable "password" {}
variable "url" {}
variable "project_id" {}

# Tenant

variable "tenant_name" {
  default = "devnet"
}

# VPC Hub Peering

variable "hub_peering" {
  description = "Enable peering to infra VPC for external access"
  default     = "default"
}

# Cloud Context Profile for VPC CIDR + Subnets

variable "vpc1_name" {
  default = "vpc-1"
}

variable "vpc1_cidr" {
  default = "172.11.0.0/16"
}

variable "vpc1_region" {
  default = "us-east4"
}

variable "cloud_vendor" {
  default = "gcp"
}

variable "vpc1_subnets" {
  type = map(object({
    name  = string
    ip    = string
    label = string
  }))
  default = {
    web-subnet = {
      name  = "web-subnet"
      ip    = "172.11.1.0/24"
      label = "web servers"
    },
    db-subnet = {
      name  = "db-subnet"
      ip    = "172.11.2.0/24"
      label = "db servers"
    }
  }
}
