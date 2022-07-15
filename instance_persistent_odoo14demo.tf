# Elastic IPS
resource "aws_eip" "odoo14demo" {
  vpc = true

  tags = {
    Name     = "Odoo14demo"
    Episodio = "Ages"
  }

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_efs_file_system" "odoo14demo" {
  creation_token   = "odoo14demo"
  encrypted        = true
  performance_mode = "generalPurpose"

  tags = {
    Name     = "EFS"
    Episodio = "Ages"
  }
}

resource "aws_efs_mount_target" "odoo14demo" {
  count           = length(data.aws_availability_zones.available.zone_ids)
  file_system_id  = aws_efs_file_system.odoo14demo.id
  subnet_id       = element(aws_subnet.privada.*.id, count.index)
  security_groups = [aws_security_group.efs.id]
}


resource "aws_instance" "odoo14demo" {
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
    volume_size           = "15"
    delete_on_termination = true
  }


  user_data = <<-EOF
                #!/bin/bash
                # ---> Updating, upgrating and installing the base
                apt updateapt update
                apt install git python3-pip python3-opencv apt-transport-https ca-certificates curl software-properties-common nfs-common -y
                mkdir /var/lib/docker
                echo "${aws_efs_file_system.odoo14demo.dns_name}:/  /var/lib/docker    nfs4   nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 0 2" >> /etc/fstab
                mount -a
                
                EOF

  tags = {
    Name     = "EC2 con persistencia en ${aws_subnet.public[count.index].availability_zone}"
    Episodio = "Ages"
  }

  depends_on = [aws_efs_file_system.odoo14demo, aws_efs_mount_target.odoo14demo]
}

resource "aws_eip_association" "odoo14demo" {
  instance_id   = aws_instance.odoo14demo[0].id
  allocation_id = aws_eip.odoo14demo.id
}

resource "null_resource" "script_odoo14demo" {
  provisioner "file" {
    source      = "script/odoo14.sh"
    destination = "/tmp/odoo14.sh"
  }
  connection {
    type        = "ssh"
    host        = aws_eip.odoo14demo.public_dns
    user        = "ubuntu"
    private_key = file(var.ssh_priv_path)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/odoo14.sh",
      "sudo sh /tmp/odoo14.sh  ~/odoo14",
    ]
  }

  depends_on = [aws_eip_association.odoo14demo]
}


