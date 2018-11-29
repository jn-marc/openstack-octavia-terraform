resource "openstack_compute_instance_v2" "front2" {
  name            = "front2"
  image_name      = "Centos75"
  flavor_name     = "small"
  key_pair        = "${var.ssh-key-name}"
  security_groups = ["default", "admin", "front", "public_web"]

  user_data = "${ data.template_cloudinit_config.front.rendered }"

  metadata {
    groups = "front-servers"
  }

  network {
    name = "${var.private-network}"
  }
}

resource "openstack_lb_member_v2" "front2" {
  name          = "front2"
  pool_id       = "${openstack_lb_pool_v2.pool1.id}"
  address       = "${openstack_compute_instance_v2.front2.network.0.fixed_ip_v4}"
  protocol_port = 80

  depends_on = [
    "openstack_lb_loadbalancer_v2.lb1",
  ]
}
