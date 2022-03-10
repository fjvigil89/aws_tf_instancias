# Create a new load balancer
/* resource "aws_elb" "loadbalance" {
  count              = length(data.aws_availability_zones.available.zone_ids)
  name               = tostring("ELB-terraform-${aws_subnet.public[count.index].availability_zone}")
  availability_zones = [aws_subnet.public[count.index].availability_zone]

  access_logs {
    bucket        = "foo"
    bucket_prefix = "bar"
    interval      = 60
  } 

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  instances                   = [aws_instance.multiple[count.index].id]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "loadbalance-terraform-elb"
    Episodio = "Informe Nube"
  }

  depends_on = [aws_vpc.informe_nube, aws_key_pair.laptop, aws_security_group.servidor_web, aws_eip_association.multiple, aws_eip_association.persistent,aws_eip_association.simple]
}


output "loadbalance_dns" {
  value = aws_elb.loadbalance[*].dns_name
} */