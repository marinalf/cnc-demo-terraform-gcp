
# CNC Credentials & GCP Project

variable "username" {}
variable "password" {}
variable "url" {}
variable "project_id" {}

# Tenant + VRF

variable "tenant_name" {
  default = "DevNet"
}

# VPC Hub Peering

variable "hub_peering" {
  description = "Enable peering to infra VPC for external access"
  default     = "default"
}

#Cloud Context Profile (VPC) + Subnets

variable "vrf_name" {
  default = "vpc-1"
}

variable "cxt_name" {
  default = "vpc-1-ctx"
}

variable "cxt_cidr" {
  default = "172.11.0.0/16"
}

variable "cxt_region" {
  default = "us-east4"
}

variable "cloud_vendor" {
  default = "gcp"
}

variable "user_subnets" {
  type = map(object({
    name  = string
    ip    = string
    label = string
  }))
  default = {
    web-subnet = {
      name  = "web-subnet"
      ip    = "172.11.3.0/24"
      label = "web servers"
    },
    db-subnet = {
      name  = "db-subnet"
      ip    = "172.11.4.0/24"
      label = "db servers"
    }
  }
}

# EPGs + Contract + Filter

variable "app_profile" {
  default = "MyApp"
}

variable "epg_web" {
  default = "Web"
}

variable "selector_web" {
  default = "Web"
}

variable "ip_based" {
  default = "IP=='172.11.1.0/24'"
}

variable "epg_db" {
  default = "DB"
}

variable "selector_db" {
  default = "DB"
}

variable "tag_based" {
  default = "custom:Name=='db-vm'"
}

variable "contract_name" {
  default = "web-to-db"
}

variable "filter_name" {
  default = "web-to-db"
}

# Internet External EPG + Contract + Filter

variable "epg_internet" {
  default = "Internet"
}

variable "selector_internet" {
  default = "Internet"
}

variable "subnet_internet" {
  default = "0.0.0.0/0"
}

variable "contract_name_internet" {
  default = "internet-access"
}

variable "filter_name_internet" {
  default = "internet-access"
}
