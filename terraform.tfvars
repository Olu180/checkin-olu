## Application configurations
region       = "eu-west-2"
app_name     = "check-in-app"
env          = "dev"
app_services = ["frontend", "backend"]

#VPC configurations
cidr               = "10.10.0.0/16"
availability_zones = ["eu-west-2a", "eu-west-2b"]
public_subnets     = ["10.10.50.0/24", "10.10.51.0/24"]
private_subnets    = ["10.10.0.0/24", "10.10.1.0/24"]

#Internal ALB configurations
internal_alb_config = {
  name = "Internal-Alb"
  listeners = {
    "HTTP" = {
      listener_port     = 80
      listener_protocol = "HTTP"

    }
  }

  ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["10.10.0.0/16"]
    }
  ]

  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["10.10.0.0/16"]
    }
  ]
}

dynamodb_table_name = "UserCheckin"

#Friendly url name for internal load balancer DNS
internal_url_name = "service.internal"

#Public ALB configurations
public_alb_config = {
  name = "Public-Alb"
  listeners = {
    "HTTP" = {
      listener_port     = 80
      listener_protocol = "HTTP"

    }
  }

  ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

#Microservices
microservice_config = {
  "Frontend" = {
    name           = "Frontend"
    is_public      = true
    container_port = 8080
    host_port      = 8080
    cpu            = 256
    memory         = 512
    desired_count  = 1
    container_envs = [{
      name  = "BACKEND_URL"
      value = "http://service.internal"
    }]
    alb_target_group = {
      port              = 8080
      protocol          = "HTTP"
      path_pattern      = ["/*"]
      health_check_path = "/"
      priority          = 1
    }
    auto_scaling = {
      max_capacity = 2
      min_capacity = 1
      cpu = {
        target_value = 75
      }
      memory = {
        target_value = 75
      }
    }
  },
  "Backend" = {
    name           = "Backend"
    is_public      = false
    container_port = 5000
    host_port      = 5000
    cpu            = 256
    memory         = 512
    desired_count  = 1
    alb_target_group = {
      port              = 5000
      protocol          = "HTTP"
      path_pattern      = ["/*"]
      health_check_path = "/"
      priority          = 1
    }
    container_envs = [{
      name  = "app"
      value = "backend"
    }]
    auto_scaling = {
      max_capacity = 2
      min_capacity = 1
      cpu = {
        target_value = 75
      }
      memory = {
        target_value = 75
      }
    }
  }
}
