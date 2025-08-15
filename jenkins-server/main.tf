resource "aws_instance" "docker-master" {
  ami                    = local.ami_id
  instance_type          = "t3.medium"
  vpc_security_group_ids = [aws_security_group.docker_allow_all.id]
  iam_instance_profile   = "TerraformAdminPermissions"
  user_data              = file("docker.sh")

  root_block_device {
    volume_size = 50
    volume_type = "gp3"
  }

  tags = {
    Name = "${var.project}-${var.environment}-${var.docker_name}"
  }
  
}