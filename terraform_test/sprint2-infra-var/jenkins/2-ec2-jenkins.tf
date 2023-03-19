module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 4.0"
  name    = "jenkins"
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  monitoring                  = var.monitoring
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.jenkins_sg.id]
  
  /*
  vpc_security_group_ids      = [module.public_bastion_sg.this_security_group_id]*/
  associate_public_ip_address = var.ec2_associate_public_ip_address
  root_block_device = [
    {
      volume_type = "gp2"
      volume_size = 30
    }
  ]
  ## aqui poner el userdata para instalar jenkins
  user_data = <<EOF
  #!/bin/bash
  sudo apt-get update -y
  sudo apt-get install -y \
  ca-certificates \
  curl \
  gnupg \
  lsb-release
  sudo mkdir -m 0755 -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo chmod a+r /etc/apt/keyrings/docker.gpg
  sudo apt-get update -y
  sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
  sudo systemctl enable docker.service
  sudo systemctl enable containerd.service
  docker run -d -p 8080:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts-jdk11
  EOF

  tags = {
    "Terraform"     = "true"
    "Environment" = var.ec2_environment
  }
}