variable "aws_profile" {
  default = "agent-build"
}
variable "env_name" {}
variable "vpc_id" {}
variable "subnet_eu_west_1a" {}
variable "subnet_eu_west_1b" {}
variable "ami_id" {}
variable "instance_type" {
  default = "t2.small"
}
variable "ssl_cert_id" {}
variable "route53_zone_id" {}
variable "route53_host_record" {}

provider "aws" {
    profile = "${var.aws_profile}"
    region = "eu-west-1"
}

resource "aws_route53_record" "www" {
  zone_id = "${var.route53_zone_id}"
  name = "${var.route53_host_record}"
  type = "A"

  alias {
    name = "${aws_elb.myapp-main.dns_name}"
    zone_id = "${aws_elb.myapp-main.zone_id}"
    evalute_target_health = true
  }
}

resource "aws_elb" "myapp-main" {
  name = "myapp-main"
  subnets = [ 
    "${var.subnet_eu_west_1a}", 
    "${var.subnet_eu_west_1b}" 
  ]
  cross_zone_load_balancing = true
  security_groups = [ "${aws_security_group.allow_web.id}" ]
  connection_draining = true
  connection_draining_timeout = 60

  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  listener {
    instance_port = 8080
    instance_protocol = "http"
    lb_port = 443
    lb_protocol = "https"
    ssl_certificate_id = "${var.ssl_cert_id}"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 30
    target = "HTTP:80/"
    interval = 60
  }

  tags {
    Name = "myapp-main-elb"
  }
}

resource "aws_launch_configuration" "myapp-v1" {
  name = "myapp-v1"
  image_id = "${var.ami_id}"
  security_groups = [ "${aws_security_group.allow_web.id}"]
  instance_type = "${var.instance_type}"
  enable_monitoring = true
  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 80
    volume_type = "gp2"
    delete_on_termination = true
    encrytped = true
  }
  ebs_block_device {
    device_name = "xvdf"
    volume_size = 20
    volume_type = "gp2"
    delete_on_termination = true
    encrytped = true
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "myapp-v1" {
  availability_zones = [
    "eu-west-1a", 
    "eu-west-1b"]
  name = "myapp-v1"
  min_size = 2
  max_size = 2
  desired_capacity = 2
  health_check_grace_period = 60
  health_check_type = "EC2"
  force_delete = false
  launch_configuration = "${aws_launch_configuration.myapp-v1.name}"
  load_balancers = ["${aws_elb.myapp-main.name}"]
  vpc_zone_identifier = [ 
    "${var.subnet_eu_west_1a}", 
    "${var.subnet_eu_west_1b}"]
  tag {
    key = "role"
    value = "www"
  }
  tag {
    key = "service"
    value = "api"
  }
}

resource "aws_security_group" "allow_web" {
  name = "allow_web"
  description = "Allow port 80 and 443"
  vpc_id = "${var.vpc_id}"

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 443
      to_port = 8080
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 5985
      to_port = 5985
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 3389
      to_port = 3389
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
}

output "domain-name" {
    value = "${aws_elb.myapp-main.dns_name}"
}
