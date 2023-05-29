
data "aci_tenant" "tenant1" {
  name = var.tenant_name
}

data "aci_cloud_account" "cloud_provider" {
  tenant_dn   = data.aci_tenant.tenant1.id
  account_id  = var.project_id
  vendor      = "gcp"
}

data "aci_vrf" "vpc1" {
  tenant_dn = data.aci_tenant.tenant1.id
  name      = var.vpc1_name
}