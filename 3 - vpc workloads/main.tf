# Reference: https://cloud.google.com/docs/terraform/get-started-with-terraform

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">=4.61.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

data "google_compute_subnetwork" "web-servers" {
  region = var.region
  name   = "vpc-1-subnet172-11-1-0x24" # using default subnet name
}

data "google_compute_subnetwork" "db-servers" {
  region = var.region
  name   = "vpc-1-subnet172-11-2-0x24" # using default subnet name
}

# Web VM

resource "google_compute_instance" "web" {
  name         = "web-vm"
  machine_type = "f1-micro"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    subnetwork = data.google_compute_subnetwork.web-servers.id

    access_config {
      # Include this section to give the VM an external IP address
    }
  }
}

# DB VM

resource "google_compute_instance" "db" {
  name         = "db-vm"
  machine_type = "f1-micro"
  zone         = var.zone
  labels = {
    name = "db-vm"
  }

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    subnetwork = data.google_compute_subnetwork.db-servers.id

  }
}