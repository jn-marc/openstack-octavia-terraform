provider "openstack" {
  user_name   = "YOUR_OPENSTACK_USERNAME"
  tenant_name = "YOUR_OPENSTACK_PROJECT_NAME"
  domain_name = "default"
  password    = "YOUR_OPENSTACK_PASSWORD"
  auth_url    = "YOUR_OPENSTACK_PUBLIC_ENDPOINT"
  region      = "regionOne"
  use_octavia = true
}
