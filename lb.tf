resource "openstack_lb_loadbalancer_v2" "lb1" {
  name               = "lb1"
  vip_subnet_id      = "${openstack_networking_subnet_v2.private_subnet.id}"
  security_group_ids = ["${openstack_networking_secgroup_v2.public_web.id}", "${openstack_networking_secgroup_v2.front.id}"]
}

resource "openstack_lb_listener_v2" "listener_http" {
  name            = "listener_http"
  protocol        = "HTTP"
  protocol_port   = 80
  loadbalancer_id = "${openstack_lb_loadbalancer_v2.lb1.id}"
}

resource "openstack_lb_pool_v2" "front_pool" {
  name        = "front_pool"
  protocol    = "HTTP"
  lb_method   = "ROUND_ROBIN"
  listener_id = "${openstack_lb_listener_v2.listener_http.id}"
}

resource "openstack_lb_monitor_v2" "front_pool_monitor" {
  pool_id        = "${openstack_lb_pool_v2.front_pool.id}"
  type           = "HTTP"
  delay          = 5
  timeout        = 10
  max_retries    = 3
  url_path       = "/heath_check.html"
  http_method    = "GET"
  expected_codes = "200"
}

resource "openstack_networking_floatingip_v2" "lb1" {
  pool = "${var.floating-ip-pool}"

  depends_on = [
    "openstack_lb_loadbalancer_v2.lb1",
  ]
}

resource "openstack_networking_floatingip_associate_v2" "lb1" {
  floating_ip = "${openstack_networking_floatingip_v2.lb1.address}"
  port_id     = "${openstack_lb_loadbalancer_v2.lb1.vip_port_id}"
}
