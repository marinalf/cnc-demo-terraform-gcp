
data "aci_cloud_cidr_pool" "vpc1_cidr" {
  cloud_context_profile_dn = aci_cloud_context_profile.ctx-vpc1.id
  addr                     = var.vpc1_cidr
}