data "template_file" "install_front" {
  template = <<EOF
#!/bin/bash
yum -y install epel-release
yum -y install nginx
systemctl enable nginx
systemctl start nginx
hostname >  /usr/share/nginx/html/index.html
echo HEALTHY > /usr/share/nginx/html/heath_check.html
EOF
}

data "template_cloudinit_config" "front" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/x-shellscript"
    content      = "${data.template_file.install_front.rendered}"
  }
}
