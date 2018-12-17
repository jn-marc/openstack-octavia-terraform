## Terraform introduction
Terraform is a tool for building, changing, and versioning infrastructure safely and efficiently. Terraform can manage existing and popular service providers as well as custom in-house solutions.

Version used:
*   Terraform 0.11.11

## Octavia Introduction
Octavia is an open source, operator-scale load balancing solution designed to work with OpenStack.

Octavia was borne out of the Neutron LBaaS project. Its conception influenced the transformation of the Neutron LBaaS project, as Neutron LBaaS moved from version 1 to version 2. Starting with the Liberty release of OpenStack, Octavia has become the reference implementation for Neutron LBaaS version 2.

Octavia accomplishes its delivery of load balancing services by managing a fleet of virtual machines servers—collectively known as amphorae— which it spins up on demand. This on-demand, horizontal scaling feature differentiates Octavia from other load balancing solutions, thereby making Octavia truly suited “for the cloud.”

## The Goal of this Project
This project demonstrates the use of Octavia with Terraform.
The Terraform plan creates a network, a subnet, a router, 2 front instances to demonstrate the Load Blancing feature.

Then we create a load balancer
```
resource "openstack_lb_loadbalancer_v2" "lb1" {
  name               = "lb1"
  vip_subnet_id      = "${openstack_networking_subnet_v2.private_subnet.id}"
  security_group_ids = ["${openstack_networking_secgroup_v2.public_web.id}", "${openstack_networking_secgroup_v2.front.id}"]
}
```

The Load Balancer has one listener on port 80.
```
resource "openstack_lb_listener_v2" "listener_http" {
  name            = "listener_http"
  protocol        = "HTTP"
  protocol_port   = 80
  loadbalancer_id = "${openstack_lb_loadbalancer_v2.lb1.id}"
}
```

A pool a front servers is binded to this listener.
```
resource "openstack_lb_pool_v2" "front_pool" {
  name        = "front_pool"
  protocol    = "HTTP"
  lb_method   = "ROUND_ROBIN"
  listener_id = "${openstack_lb_listener_v2.listener_http.id}"
}
```

Each front is included in this pool
```
resource "openstack_lb_member_v2" "front1" {
  name          = "front1"
  pool_id       = "${openstack_lb_pool_v2.front_pool.id}"
  address       = "${openstack_compute_instance_v2.front1.network.0.fixed_ip_v4}"
  protocol_port = 80

  depends_on = [
    "openstack_lb_loadbalancer_v2.lb1",
  ]
}
```

We then add Layer7 Health Checking to the members of the pool :
```
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
```

The output.tf file prints the Internal VIP of the LoadBalancer at the end of the "terraform deploy" step:
```
output "lb1_vip" {
  value = "${openstack_lb_loadbalancer_v2.lb1.vip_address}"
}
```

As we also binded a Floating IP to this VIP, we also print the Public Floating IP :
```
output "lb1_vip_floating_ip" {
  value = "${openstack_networking_floatingip_v2.lb1.address}"
}
```

## Openstack authentification
The Terraform OpenStack provider is used to interact with the many resources supported by OpenStack. The provider needs to be configured with the proper credentials before it can be used.

Adapt the provider.tf file, in order to authenticate to your OpenStack environment.

```
provider "openstack" {
  user_name   = "my_openstack_user"
  tenant_name = "my_openstacktenant"
  password    = "my_openstack_user_secret"
  auth_url    = "http://your-cloud-provider.com"
}
```

## Getting Started
Download Terraform Binary : [https://www.terraform.io/downloads.html](https://www.terraform.io/downloads.html)

Clone this project
```
git clone git@github.com:jn-marc/openstack-octavia-terraform.git
```

Before terraform apply you must download provider plugin:
```
terraform init
```

Display plan before apply manifest
```
terraform plan
```

Apply manifest
```
terraform apply
```

Destroy stack
```
terraform destroy
```
