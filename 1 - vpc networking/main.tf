### Define Cloud Networking Policies ###

# Tenant and Cloud Account mapping

resource "aci_tenant" "tenant1" {
  name = var.tenant_name
  description = "Created by Terraform"
}

resource "aci_cloud_account" "cloud_provider" {
  name        = "gcp_cloud"
  tenant_dn   = aci_tenant.tenant1.id
  account_id  = var.project_id
  access_type = "managed"
  vendor      = "gcp"
}

resource "aci_tenant_to_cloud_account" "cloud_acct_project" {
  tenant_dn        = aci_tenant.tenant1.id
  cloud_account_dn = aci_cloud_account.cloud_provider.id
}

# VRF / VPCs

resource "aci_vrf" "vpc1" {
  tenant_dn = aci_tenant.tenant1.id
  name      = var.vpc1_name
}

# Cloud Context Profile for VPC + Subnets

resource "aci_cloud_context_profile" "ctx-vpc1" {
  tenant_dn                = aci_tenant.tenant1.id
  name                     = var.vpc1_name
  primary_cidr             = var.vpc1_cidr
  region                   = var.vpc1_region
  cloud_vendor             = var.cloud_vendor
  relation_cloud_rs_to_ctx = aci_vrf.vpc1.id
  hub_network              = "uni/tn-infra/gwrouterp-${var.hub_peering}" # Required for external connectivity via Hub VPC
}

# Add User Subnets

resource "aci_cloud_subnet" "vpc1_subnets" {
  for_each           = var.vpc1_subnets
  cloud_cidr_pool_dn = data.aci_cloud_cidr_pool.vpc1_cidr.id
  name               = each.value.name
  ip                 = each.value.ip
  subnet_group_label = each.value.label
}
