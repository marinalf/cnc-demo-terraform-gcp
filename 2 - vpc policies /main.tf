
### VPC1 Firewall Policies and Rules ###

resource "aci_cloud_applicationcontainer" "myapp" {
  tenant_dn = data.aci_tenant.tenant1.id
  name      = var.app_profile
}

# Web EPG

resource "aci_cloud_epg" "epg_web" {
  name                            = var.epg_web
  cloud_applicationcontainer_dn   = aci_cloud_applicationcontainer.myapp.id
  relation_fv_rs_cons             = [aci_contract.web_to_db.id]
  relation_fv_rs_prov             = [aci_contract.internet_access.id]
  relation_cloud_rs_cloud_epg_ctx = data.aci_vrf.vpc1.id
}

resource "aci_cloud_endpoint_selector" "epg_web_selector" {
  cloud_epg_dn     = aci_cloud_epg.epg_web.id
  name             = var.web_selector
  match_expression = var.ip_based
}

# DB EPG

resource "aci_cloud_epg" "epg_db" {
  name                            = var.epg_db
  cloud_applicationcontainer_dn   = aci_cloud_applicationcontainer.myapp.id
  relation_fv_rs_prov             = [aci_contract.web_to_db.id]
  relation_cloud_rs_cloud_epg_ctx = data.aci_vrf.vpc1.id
}

resource "aci_cloud_endpoint_selector" "epg_db_selector" {
  cloud_epg_dn     = aci_cloud_epg.epg_db.id
  name             = var.db_selector
  match_expression = var.tag_based
}

# Web to DB Contract + Filter

resource "aci_contract" "web_to_db" {
  tenant_dn = data.aci_tenant.tenant1.id
  name      = var.web_to_db_contract
}

resource "aci_filter" "web_to_db" {
  tenant_dn = data.aci_tenant.tenant1.id
  name      = var.web_to_db_filter
}

resource "aci_filter_entry" "icmp" {
  name      = "icmp"
  filter_dn = aci_filter.web_to_db.id
  ether_t   = "ip"
  prot      = "icmp"
}

resource "aci_contract_subject" "web_to_db" {
  contract_dn                  = aci_contract.web_to_db.id
  name                         = "web_to_db"
  relation_vz_rs_subj_filt_att = [aci_filter.web_to_db.id]
}

# Cloud External EPG for Internet Access

resource "aci_cloud_external_epg" "vpc1_internet" {
  name                            = var.epg_internet
  cloud_applicationcontainer_dn   = aci_cloud_applicationcontainer.myapp.id
  relation_fv_rs_cons             = [aci_contract.internet_access.id]
  relation_cloud_rs_cloud_epg_ctx = data.aci_vrf.vpc1.id
  route_reachability              = "internet"
}

resource "aci_cloud_endpoint_selectorfor_external_epgs" "vpc1_ext_epg_selector" {
  cloud_external_epg_dn = aci_cloud_external_epg.vpc1_internet.id
  name                  = var.internet_selector_name
  subnet                = var.internet_selector_subnet
}

# Contract for Internet Access + Filter

resource "aci_contract" "internet_access" {
  tenant_dn = data.aci_tenant.tenant1.id
  name      = var.internet_contract
}

resource "aci_filter" "internet_access" {
  tenant_dn = data.aci_tenant.tenant1.id
  name      = var.internet_filter
}

resource "aci_filter_entry" "all" {
  name      = "all"
  filter_dn = aci_filter.internet_access.id
  ether_t   = "unspecified"
}

resource "aci_contract_subject" "internet_access" {
  contract_dn                  = aci_contract.internet_access.id
  name                         = "internet_access"
  relation_vz_rs_subj_filt_att = [aci_filter.internet_access.id]
}
