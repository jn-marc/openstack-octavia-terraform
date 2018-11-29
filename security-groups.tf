/*###############################################################################
 ADMIN SECURITY GROUP
###############################################################################*/

resource "openstack_networking_secgroup_v2" "admin" {
  name                 = "admin"
  delete_default_rules = true
  description          = "Rules for and admin"
}

resource "openstack_networking_secgroup_rule_v2" "admin-ssh" {
  count             = "${length(var.whitelist_ips)}"
  security_group_id = "${openstack_networking_secgroup_v2.admin.id}"
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_min    = 22
  port_range_max    = 22
  protocol          = "tcp"
  remote_ip_prefix  = "${element(var.whitelist_ips,  count.index)}"
}

/*###############################################################################
 WEB SECURITY GROUP
###############################################################################*/
resource "openstack_networking_secgroup_v2" "public_web" {
  name                 = "public_web"
  delete_default_rules = true
  description          = "Rules for public web access"
}

resource "openstack_networking_secgroup_rule_v2" "web-http" {
  security_group_id = "${openstack_networking_secgroup_v2.public_web.id}"
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_min    = 80
  port_range_max    = 80
  protocol          = "tcp"
  remote_ip_prefix  = "0.0.0.0/0"
}

resource "openstack_networking_secgroup_rule_v2" "web-https" {
  security_group_id = "${openstack_networking_secgroup_v2.public_web.id}"
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_min    = 443
  port_range_max    = 443
  protocol          = "tcp"
  remote_ip_prefix  = "0.0.0.0/0"
}

/*###############################################################################
 FRONT SECURITY GROUP
###############################################################################*/
resource "openstack_networking_secgroup_v2" "front" {
  name                 = "front"
  delete_default_rules = true
  description          = "Rules for front access"
}

resource "openstack_networking_secgroup_rule_v2" "front-http" {
  security_group_id = "${openstack_networking_secgroup_v2.front.id}"
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_min    = 80
  port_range_max    = 80
  protocol          = "tcp"
  remote_group_id   = "${openstack_networking_secgroup_v2.front.id}"
}
