resource "openstack_compute_keypair_v2" "automation" {
  name       = "automation"
  public_key = "YOUR_PUBLIC_KEY"
}
