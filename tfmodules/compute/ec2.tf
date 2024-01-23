resource "aws_instance" "app_server" {
  count                       = length(var.subnet_id)
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = element(var.subnet_id, count.index)
  vpc_security_group_ids      = [var.sg]
  associate_public_ip_address = var.public_access
  key_name                    = aws_key_pair.imtt_test_key.key_name
  root_block_device {
    volume_type           = "gp2"
    volume_size           = 100
    delete_on_termination = true
  }
  user_data              = var.user_data
  tags = {
    Name = "${var.project}-${var.env}-instance"
  }
}

resource "aws_eip" "app_server" {
  count = length(aws_instance.app_server)
  instance = aws_instance.app_server[count.index].id
  vpc      = true
}

resource "aws_key_pair" "imtt_test_key" {
  key_name   = var.ssh_key_name
  public_key = var.pub_key
}

# resource "aws_ebs_volume" "volume" {
#   availability_zone = aws_instance.app_server.availability_zone
#   size = 125
#   type = "st1"
#   tags = {
#     Name = "${var.project}-${var.env}-volume"
#   }
# }

# resource "aws_volume_attachment" "attachment" {
#   volume_id   = aws_ebs_volume.volume.id
#   instance_id = aws_instance.app_server.id
#   device_name = "/dev/sdd"
# #   provisioner "remote-exec" {
# #     inline = [
# #         "sudo mkdir /data -p",
# #         # For CentOS Stream 8	ap-southeast-1	x86_64	ami-023f396766365767c
# #         # - sudo mkfs -t ext4 /dev/xvdd
# #         # - sudo echo '/dev/xvdd /data xfs defaults 0 0' >> /etc/fstab
# #         #For CentOS Stream 8	ap-southeast-1	aarch64	ami-042935ebfacfd6d5d
# #         "sudo mkfs -t ext4 /dev/nvme1n1",
# #         "sudo echo /dev/nvme1n1 /data xfs defaults 0 0' >> /etc/fstab",
# #         "sudo mount -a",
# #     ]
# #     connection {
# #     user = "ubuntu"
# #     host = "${aws_eip.lb.public_ip}"
# #     private_key = "${file("C:\\Users\\MSI\\Downloads\\workspace\\aws\\infrastructure-live-v2\\test\\ec2\\key_pair\\id_rsa")}"
# #     }
# #   }
# #   provisioner "remote-exec" {
# #     when = "destroy"
# #     inline = [
# #     "sudo umount /data"
# #     ]
# #     connection {
# #     user = "ubuntu"
# #     host = "${aws_eip.aws_instance.app_server.public_ip}"
# #     private_key = "${file("C:\\Users\\MSI\\Downloads\\workspace\\aws\\infrastructure-live-v2\\test\\ec2\\key_pair\\id_rsa")}"
# #     }
# #  }
# }