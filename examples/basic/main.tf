provider "aws" {
  region = "us-east-1"
}

locals {
  containers = {
    backend = {
      hostname = "dev-app"
      web_path = "/api"
      protocol = "HTTP"
      cpu      = 512
      memory   = 1024
      port     = 3003
    }
  }
}

module "cognito" {
  source = "../../"

  region             = "us-east-1"
  stage_name         = "myproject-dev"
  domain_name        = "domain.tld"
  app_containers_map = local.containers

  tags = {
    Name = "myproject-dev-cognito"
  }
}
