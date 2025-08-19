resource "aws_instance" "jenkins-master" {
  ami                    = local.ami_id
  instance_type          = "t3.medium"
  vpc_security_group_ids = [aws_security_group.jenkins_allow_all.id]
  iam_instance_profile   = "TerraformAdminPermissions"
  user_data              = file("jenkins.sh")

  root_block_device {
    volume_size = 50
    volume_type = "gp3"
  }

  tags = {
    Name = "${var.project}-${var.environment}-${var.jenkins_name}"
  }

}

resource "aws_security_group" "jenkins_allow_all" {
  name        = "jenkins_sg"
  description = "sg for jenkins"

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "jenkins_sg"
  }
}

resource "aws_route53_record" "jenkins-record" {
  zone_id = var.zone_id
  type    = "A"
  ttl     = "1"
  records = [aws_instance.jenkins-master.public_ip]
  name    = "jenkins-master.${var.environment}.${var.zone_name}" # jenkins-master.dev.liveyourlife.site
}
