output "lb1_vip_floating_ip" {
  value = "${openstack_networking_floatingip_v2.lb1.address}"
}

output "lb1_vip" {
  value = "${openstack_lb_loadbalancer_v2.lb1.vip_address}"
}
