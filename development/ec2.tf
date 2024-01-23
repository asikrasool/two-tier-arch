module "compute" {
  source = "../tfmodules/compute"
  # ami                  = "ami-0c7217cdde317cfec" #ubuntu 22.04
  ami = "ami-0a3c3a20c09d6f377" #AL2
  # ami                  = "ami-042935ebfacfd6d5d" #a1
  # instance_type        = "a1.2xlarge" # 4vCPU,16GB Ram
  instance_type = "t2.micro" # 8vCPU,16GB Ram
  sg            = aws_security_group.ec2_sg1.id
  env           = "cloudbees-${var.env}"
  project       = var.project_name
  ssh_key_name  = "cloudbees_ec2_key_test"
  pub_key       = file("../files/id_rsa.pub")
  public_access = "true"
  subnet_id     = module.vpc.public_subnet_ids
  user_data     = file("../files/user_data.sh")
}


resource "null_resource" "null" {
  count = length(module.compute.public_ip)

  provisioner "file" {
    source      = "../files/user_data.sh"
    destination = "/home/ec2-user/userdata.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo su",
      "chmod +x /home/ec2-user/userdata.sh",
      "sh /home/ec2-user/userdata.sh",
    ]
    on_failure = continue
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    port        = "22"
    host        = element(module.compute.public_ip, count.index)
    private_key = file(var.ssh_private_key)
  }

}
