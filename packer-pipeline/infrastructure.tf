variable "aws_profile" {
  default = "agent-build"
}
variable "vpc_id" {}
variable "subnet_eu_west_1a" {}
variable "subnet_eu_west_1b" {}
variable "ami_id" {}
variable "instance_type" {
  default = "t2.small"
}

provider "aws" {
    profile = "${var.aws_profile}"
    region = "eu-west-1"
}

resource "aws_elb" "myapp-main" {
  name = "myapp-main"
  subnets = [ 
    "${var.subnet_eu_west_1a}", 
    "${var.subnet_eu_west_1b}" 
  ]
  cross_zone_load_balancing = true
  security_groups = [ "${aws_security_group.allow_web.id}" ]

  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 30
    target = "HTTP:80/"
    interval = 60
  }

}

resource "aws_launch_configuration" "myapp-v1" {
    name = "myapp-v1"
    image_id = "${var.ami_id}"
    security_groups = [ "${aws_security_group.allow_web.id}"]
    instance_type = "${var.instance_type}"
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
}

resource "aws_security_group" "allow_web" {
  name = "allow_web"
  description = "Allow port 80"
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
