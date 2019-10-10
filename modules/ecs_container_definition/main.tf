#
# This code was adapted from the `terraform-aws-ecs-container-definition` module from Cloud Posse, LLC on 2018-09-18.
# Available here: https://github.com/cloudposse/terraform-aws-ecs-container-definition
#

locals {
  # null_resource turns "true" into true, adding a temporary string will fix that problem
  safe_search_replace_string = "#keep_true_a_string_hack#"
}

locals {
  hostname = var.hostname == null ? {} : {hostname = var.hostname}
  port_mappings = {
    with_port = [
      {
        containerPort = var.container_port
        hostPort      = var.host_port
        protocol      = var.protocol
      },
    ]
    without_port = []
  }

  ulimits = {
    with_ulimits = [
      {
        softLimit = var.ulimit_soft_limit
        hardLimit = var.ulimit_hard_limit
        name      = var.ulimit_name
      },
    ]
    without_ulimits = []
  }

  repository_credentials = {
    with_credentials = {
      credentialsParameter = var.repository_credentials_secret_arn
    }
    without_credentials = {}
  }

  use_port        = var.container_port == "" ? "without_port" : "with_port"
  use_credentials = var.repository_credentials_secret_arn == "" ? "without_credentials" : "with_credentials"
  use_ulimits     = var.ulimit_soft_limit == "" && var.ulimit_hard_limit == "" ? "without_ulimits" : "with_ulimits"

  container_definitions = [
//    merge({
    {
      name                   = var.container_name
      image                  = var.container_image
      memory                 = var.container_memory
      memoryReservation      = var.container_memory_reservation
      cpu                    = var.container_cpu
      essential              = var.essential
      entryPoint             = var.entrypoint
      command                = var.container_command
      workingDirectory       = var.working_directory
      readonlyRootFilesystem = var.readonly_root_filesystem
      dockerLabels           = local.docker_labels
//      privileged             = var.privileged
      environment            = var.container_envvars
      secrets                = var.container_secrets
      mountPoints            = var.mountpoints
            portMappings           = local.port_mappings[local.use_port]
//      portMappings           = [
//        {
//          containerPort = var.container_port
//          hostPort      = var.host_port
//          protocol      = var.protocol
//        }
//      ]
      healthCheck            = var.healthcheck
      repositoryCredentials  = local.repository_credentials[local.use_credentials]
      linuxParameters        = {
        initProcessEnabled = var.container_init_process_enabled ? true : false
      }
      ulimits                = local.ulimits[local.use_ulimits]
      logConfiguration       = {
        logDriver = var.log_driver
        options   = var.log_options
      }
    }
//    }, local.hostname),
  ]
}

