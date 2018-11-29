resource "openstack_networking_network_v2" "private-network" {
  name           = "${var.private-network}"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "private_subnet" {
  name            = "private_subnet"
  network_id      = "${openstack_networking_network_v2.private-network.id}"
  cidr            = "10.0.1.0/24"
  dns_nameservers = ["8.8.8.8", "8.8.4.4"]
}

resource "openstack_networking_router_v2" "r1" {
  name                = "r1"
  external_network_id = "77f53573-55f1-478b-bc73-f7fed9f2176c"
  admin_state_up      = true
}

resource "openstack_networking_router_interface_v2" "r1-interface" {
  router_id = "${openstack_networking_router_v2.r1.id}"
  subnet_id = "${openstack_networking_subnet_v2.private_subnet.id}"
}
