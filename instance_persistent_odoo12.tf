# Elastic IPS
resource "aws_eip" "odoo12" {
  vpc = true

  tags = {
    Name     = "Odoo12"
    Episodio = "Ages"
  }

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_efs_file_system" "odoo12" {
  creation_token   = "odoo12"
  encrypted        = true
  performance_mode = "generalPurpose"

  tags = {
    Name     = "EFS"
    Episodio = "Ages"
  }
}

resource "aws_efs_mount_target" "odoo12" {
  count           = length(data.aws_availability_zones.available.zone_ids)
  file_system_id  = aws_efs_file_system.odoo12.id
  subnet_id       = element(aws_subnet.privada.*.id, count.index)
  security_groups = [aws_security_group.efs.id]
}


resource "aws_instance" "odoo12" {
  count = 1
  #availability_zone      = "eu-west-1b"
  ami                    = "ami-0d527b8c289b4af7f" // AMI son regionales (distintas IDS por region) instancia de ubuntu en la region de irlandia
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public[1].id
  vpc_security_group_ids = concat([aws_security_group.servidor_web.id], [aws_security_group.efs.id], [aws_default_security_group.default.id])
  key_name               = aws_key_pair.laptop.id

  lifecycle {
    create_before_destroy = true
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "10"
    delete_on_termination = true
  }


  user_data = <<-EOF
                #!/bin/bash
                # ---> Updating, upgrating and installing the base
                apt update
                apt install git python3-pip apt-transport-https ca-certificates curl software-properties-common nfs-common -y
                mkdir /var/lib/docker
                echo "${aws_efs_file_system.odoo12.dns_name}:/  /var/lib/docker    nfs4   nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 0 2" >> /etc/fstab
                mount -a
                                   
                EOF

  tags = {
    Name     = "EC2 con persistencia en ${aws_subnet.public[count.index].availability_zone}"
    Episodio = "Ages"
  }

  depends_on = [aws_efs_file_system.odoo12, aws_efs_mount_target.odoo12]
}

resource "aws_eip_association" "odoo12" {
  instance_id   = aws_instance.odoo12[0].id
  allocation_id = aws_eip.odoo12.id
}

resource "null_resource" "script_odoo12" {
  provisioner "file" {
    source      = "script/odoo12.sh"
    destination = "/tmp/odoo12.sh"
  }
  connection {
    type        = "ssh"
    host        = aws_eip.odoo12.public_dns
    user        = "ubuntu"
    private_key = file(var.ssh_priv_path)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/odoo12.sh",
      "sudo sh /tmp/odoo12.sh  ~/odoo12",
    ]
  }

  depends_on = [aws_eip_association.odoo12]
}


