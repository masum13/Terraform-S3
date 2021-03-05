<!-- VSCode Markdown Exclusions-->
<!-- markdownlint-disable MD025 Single Title Headers-->
# Tapestry AWS ECS terraform module

<br>

![Version-Badge](https://img.shields.io/badge/MODULE%20VERSION-v1.0.0-Green?style=for-the-badge&logo=terraform&logoColor=BLUE&logoWidth=25)

<br><br>


# Getting Started

  **Table of Contents**

  * [Supported in this module](#supported-in-this-module)
  * [Basic ecs capacity provider configuration Variables](#basic-ecs-capacity-provider-configuration-variables)
  * [Basic ecs cluster configuration Variables](#basic-ecs-cluster-configuration-variables)
  * [Basic ecs service configuration Variables](#basic-ecs-service-configuration-variables)
  * [Basic ecs task definition configuration Variables](#basic-ecs-task-definition-configuration-variables)
  * [Variables for container definition](#variables-for-container-definition)
  * [Log group configuration](#log-group-configuration)
  * [Sample plan with Cluster creation with EC2](#sample-plan-with-cluster-creation-with-ec2)
  * [Sample plan with Cluster creation with FARGATE](#sample-plan-with-cluster-creation-with-fargate)
  * [Sample to attach EFS to the ECS task](#sample-to-attach-efs-to-the-ecs-task)
  * [Requirements](#requirements)
  * [Recommended](#recommended)

# Supported in this module
  - Create ecs capacity provider for ecs cluster
  - Create ecs cluster
  - Create ecs service for ecs cluster
  - Create ecs task definition for ecs service
  - Create cloudwatch log group for ecs task

<br><br>

#  Basic ecs capacity provider configuration Variables

        ecs_capacity_provider_name      =  "name-of-cpacity-provider"  
        ecs_capacity_provider_tags      =  { example = "tags"}
        auto_scaling_group_arn          =  "<asg_arn>"    
        managed_termination_protection  =  "ENABLED/DISABLED"                   #optional
        managed_scaling                 =   [{
                                                maximum_scaling_step_size = max-size-of-scaling
                                                minimum_scaling_step_size = min-size-of-scaling
                                                status                    = "status-of-scaling"
                                                target_capacity           = target-capacity
                                            }]

#  Basic ecs cluster configuration Variables

        cluster_name                       =  "name-of-cluster"  
        ecs_tags                           =  { example = "tags"}            
        capacity_providers                 =  [list-of-cpacity-provider]

   **with module default values**  
     # below default values if needed can be overridden
    
        default_capacity_provider_strategy =  null        
        insights_setting                   =  null
        capacity_providers                 =  [] 

#  Basic ecs service configuration Variables

        ecs_service_name              =  "name-of-service"  
        ecs_service_tags              =  { example = "tags"}
        service_launch_type           =  "EC2/FARGATE"

   **with module default values**  
     # below default values if needed can be overridden
    
        existing_cluster_arn                      =  null                 # If want to add service to existing cluster than set value to arn of cluster otherwise not. 
        ecs_service_type_of_deployment_controller =  "ECS"
        tasks_desired_count                       =  0
        tasks_minimum_healthy_percent             =  0
        tasks_maximum_percent                     =  0
        force_new_deployment                      =  true 
        health_check_grace_period_seconds         =  null
        iam_role_arn                              =  "<iam_role_arn>"
        platform_version                          =  "1.4.0"              # IF service_launch_type is FARGATE
        propagate_tags                            = null
        scheduling_strategy                       = "REPLICA/CODE_DEPLOY"
        wait_for_steady_state                     = false
        capacity_provider_strategy                = []
        ordered_placement_strategy                = []
        network_configuration                     = null
        load_balancer                             = null
        lb_type                                   = null                  # If load balancer is define than it's require.
        target_container_name                     = null                  # If load balancer is define than it's require. 
        service_registries                        = []

# Basic ecs task definition configuration Variables

        family_name               =  "name-of-family"
        task_definition_tag       =  { example = "tags"}

   **with module default values**  
     # below default values if needed can be overridden

        task_role_arn             =  "<iam_role_arn>"
        task_network_mode         =  "bridge"           # For faragte set value to "awsvpc"
        task_cpu                  =  null               # For FARGATE set value
        task_memory               =  null               # For FARGATE set value
        task_execution_role_arn   =  ""
        ipc_mode                  = null
        pid_mode                  = null
        volume                    = []
        placement_constraints     = []
        proxy_configuration       = []
        inference_accelerator     = []

#  Variables for container definition 

        container_name               =  "name-of-container"
        container_image              =  "image-of-container"
        container_memory             =  "memory"
        container_cpu                =  "cpu"

   **with module default values**  
     # below default values if needed can be overridden

        container_command                =  []   
        container_dependsOn              =  []
        container_disableNetworking      =  false
        container_dnsSearchDomains       =  []
        container_dnsServers             =  []
        container_dockerLabels           =  {}
        container_dockerSecurityOptions  =  []
        container_entryPoint             =  []
        container_environment            =  []
        container_environmentFiles       =  []
        container_essential              =  true
        container_extraHosts             =  []
        container_firelensConfiguration  =  {}
        container_healthCheck            =  {}
        container_hostname               =  ""
        container_interactive            =  false
        container_links                  =  []
        container_linuxParameters        =  {}
        container_logConfiguration       =  {}
        container_memoryReservation      =  {}
        container_mountPoints            =  []
        container_portMappings           =  []
        container_privileged             =  false
        container_pseudoTerminal         =  false
        container_readonlyRootFilesystem =  {}
        container_repositoryCredentials  =  []
        container_resourceRequirements   =  []
        container_secrets                =  []
        container_startTimeout           =  0
        container_stopTimeout            =  0
        container_systemControls         =  []
        container_ulimits                =  []
        container_user                   =  ""
        container_volumesFrom            =  []
        container_workingDirectory       =  ""

#  Log group configuration  

        ecs_log_group_name                    =  "name-of-log-group"
        ecs_cloudwatch_logs_retention_in_days =  "retention_in_days"
        ecs_cloudwatch_logs_kms_key_id        =  "id-of-kms-key"
        task_definition_tag                   =  { example = "tags"}

# Sample plan with Cluster creation with EC2

    module "ecs" {
      source                       = "../../aws_ecs"
      create_ecs_capacity_provider = true 
      ecs_capacity_provider_name   = "tapestry"
      ecs_auto_scalling_grp_arn    = "xxxxx"
      capacity_providers           = ["FARGATE", "FARGATE_SPOT"]
      managed_scaling              = [{
                                        maximum_scaling_step_size  = 1
                                        minimum_scaling_step_size  = 1
                                        status                     = "ENABLED"
                                        target_capacity            = 1:q!
                                     }]
      
      create_cluster                = true
      cluster_name                  = "tapestry"

      ecs_service_name              = "tapestry"
      tasks_desired_count           = 1
      tasks_maximum_percent         = 200
      tasks_minimum_healthy_percent = 100

      service_launch_type           = "EC2"

      family_name                   = "tapestry-family"

      // container_definition
      container_name                = "tapestry"
      container_image               = "xxxx"
      container_memory              = 512
      container_portMappings        = [
                                        {
                                          "containerPort" = xxxx
                                          "hostPort"      = xxxx
                                          "protocol"      = "xxxx"
                                        }
                                      ]
      container_cpu                 = 256
      container_essential           = true
      container_logConfiguration    = {
                                      "logDriver" = "awslogs"
                                      "options" = {
                                          // cloudwatch log group name
                                          "awslogs-group" = "tapestry_log_group"
                                          "awslogs-region" = "us-east-1"
                                          // cloud watch log stream name
                                          "awslogs-stream-prefix" = "tapestry"
                                        }
                                      }
      task_execution_role_arn       = "xxxxx"
      
      create_cloudwatch_ecs_log_group       = true
      ecs_log_group_name                    = "tapestry_log_group"
      ecs_cloudwatch_logs_retention_in_days = 7
    }

      plan:
      # module.ecs.aws_cloudwatch_log_group.ecs_log_group[0] will be created
      resource "aws_cloudwatch_log_group" "ecs_log_group" {
          arn               = (known after apply)
          id                = (known after apply)
          name              = "tapestry_log_group"
          retention_in_days = 7
      }

      # module.ecs.aws_ecs_capacity_provider.this[0] will be created
      resource "aws_ecs_capacity_provider" "this" {
          arn  = (known after apply)
          id   = (known after apply)
          name = "tapestry_test"

          auto_scaling_group_provider {
              auto_scaling_group_arn         = (known after apply)
              managed_termination_protection = "DISABLED"

              managed_scaling {
                  instance_warmup_period    = (known after apply)
                  maximum_scaling_step_size = 1
                  minimum_scaling_step_size = 1
                  status                    = "ENABLED"
                  target_capacity           = 2
              }
          }
      }

      # module.ecs.aws_ecs_cluster.this[0] will be created
      resource "aws_ecs_cluster" "this" {
          arn                = (known after apply)
          capacity_providers = [
              "tapestry_test",
          ]
          id                 = (known after apply)
          name               = "tapestry-cluster"

          setting {
              name  = (known after apply)
              value = (known after apply)
          }
      }

      # module.ecs.aws_ecs_service.this[0] will be created
      resource "aws_ecs_service" "this" {
          cluster                            = (known after apply)
          deployment_maximum_percent         = 200
          deployment_minimum_healthy_percent = 100
          desired_count                      = 1
          enable_ecs_managed_tags            = true
          force_new_deployment               = true
          iam_role                           = (known after apply)
          id                                 = (known after apply)
          launch_type                        = "EC2"
          name                               = "tapestry-coach-service"
          platform_version                   = (known after apply)
          scheduling_strategy                = "REPLICA"
          task_definition                    = (known after apply)
          wait_for_steady_state              = false

          deployment_controller {
              type = "ECS"
          }
      }

      # module.ecs.aws_ecs_task_definition.this[0] will be created
      resource "aws_ecs_task_definition" "this" {
          arn                      = (known after apply)
          container_definitions    = jsonencode(
              [
                  {
                      cpu                    = 256
                      disableNetworking      = false
                      essential              = true
                      image                  = "shankarhpatel/coach-reports:latest"
                      interactive            = false
                      logConfiguration       = {
                          logDriver = "awslogs"
                          options   = {
                              awslogs-group         = "tapestry_log_group"
                              awslogs-region        = "us-east-1"
                              awslogs-stream-prefix = "tapestry"
                          }
                      }
                      memory                 = 512
                      name                   = "tapestry-coach-reports"
                  },
              ]
          )
          execution_role_arn       = (known after apply)
          family                   = "tapestryfamily_coach"
          id                       = (known after apply)
          network_mode             = "bridge"
          requires_compatibilities = [
              "EC2",
          ]
          revision                 = (known after apply)
      }

# Sample plan with Cluster creation with FARGATE

    module "ecs" {
      source                            = "../../aws_ecs"
      ecs_capacity_provider_name        = "tapestry"
      capacity_providers                = ["FARGATE", "FARGATE_SPOT"]
      managed_scaling                   = [{
                                            maximum_scaling_step_size  = 1
                                            minimum_scaling_step_size  = 1
                                            status                     = "ENABLED"
                                            target_capacity            = 2
                                          }]
      
      create_cluster                    = true
      cluster_name                      = "tapestry"

      ecs_service_name                  = "coach-smart"
      tasks_desired_count               = 1
      tasks_maximum_percent             = 100
      tasks_minimum_healthy_percent     = 1

      ecs_use_fargate                   = true
      service_launch_type               = "FARGATE"
      task_network_mode                 = "awsvpc"
      network_configuration             = [{
                                            subnets = ["subnet-fd2d7ab0"]                   // required
                                            security_groups = ["sg-081af78dd8176f46c"]      // optional 
                                            assign_public_ip = true                         // keep false if need to setup in private zone
                                          }]

      task_cpu                          = 512   
      task_memory                       = 1024 
      
      task_execution_role_arn           = "xxxxx"

      // container_definition
      container_name                    = "tapestry"
      container_image                   = "xxxx"
      container_memory                  = 256
      container_portMappings            = [
                                            {
                                              "containerPort" = xxxx
                                              "hostPort"      = xxxx
                                              "protocol"      = "xxxx"
                                            }
                                          ]
      container_logConfiguration        = {
                                            "logDriver" = "awslogs"
                                            "options" = {
                                              // cloudwatch log group name
                                              "awslogs-group" = "tapestry_log_group"
                                              "awslogs-region" = "us-east-1"
                                              // cloud watch log strem name
                                              "awslogs-stream-prefix" = "tapestry"
                                            }
                                          }

      container_cpu                   = 128
      container_essential             = true

      create_cloudwatch_ecs_log_group       = true
      ecs_log_group_name                    = "tapestry_log_group"
      ecs_cloudwatch_logs_retention_in_days = 7 
    }

    plan:
    module.ecs.aws_cloudwatch_log_group.ecs_log_group[0] will be created
    resource "aws_cloudwatch_log_group" "ecs_log_group" {
        arn               = (known after apply)
        id                = (known after apply)
        name              = "tapestry_log_group"
        retention_in_days = 7
    }

    # module.ecs.aws_ecs_cluster.this[0] will be created
    resource "aws_ecs_cluster" "this" {
        arn  = (known after apply)
        id   = (known after apply)
        name = "tapestry-cluster"

        setting {
            name  = (known after apply)
            value = (known after apply)
        }
    }

    # module.ecs.aws_ecs_service.this[0] will be created
    resource "aws_ecs_service" "this" {
        cluster                            = (known after apply)
        deployment_maximum_percent         = 200
        deployment_minimum_healthy_percent = 100
        desired_count                      = 1
        enable_ecs_managed_tags            = true
        force_new_deployment               = true
        iam_role                           = (known after apply)
        id                                 = (known after apply)
        launch_type                        = "FARGATE"
        name                               = "tapestry-coach-service"
        platform_version                   = "1.4.0"
        scheduling_strategy                = "REPLICA"
        task_definition                    = (known after apply)
        wait_for_steady_state              = false

        deployment_controller {
            type = "ECS"
        }

        network_configuration {
            assign_public_ip = false
            subnets          = [
                "subnet-xxx",
                "subnet-xxx",
            ]
        }
    }

    # module.ecs.aws_ecs_task_definition.this[0] will be created
    resource "aws_ecs_task_definition" "this" {
        arn                      = (known after apply)
        container_definitions    = jsonencode(
            [
                {
                    cpu                    = 256
                    disableNetworking      = false
                    essential              = true
                    image                  = "xxx"
                    interactive            = false
                    logConfiguration       = {
                        logDriver = "awslogs"
                        options   = {
                            awslogs-group         = "tapestry_log_group"
                            awslogs-region        = "us-east-1"
                            awslogs-stream-prefix = "tapestry"
                        }
                    }
                    memory                 = 512
                    name                   = "tapestry"
                },
            ]
        )
        cpu                      = "512"
        execution_role_arn       = (known after apply)
        family                   = "tapestry"
        id                       = (known after apply)
        memory                   = "1024"
        network_mode             = "awsvpc"
        requires_compatibilities = [
            "FARGATE",
        ]
        revision                 = (known after apply)
    }

 **Creating ECS service and task definition in existing cluster**
  #set create_cluster variable to false, so terraform code do not build the ECS cluster and set existing_cluster_arn to arn of ECS cluster, so ECS service can join existing cluster.

# Sample to attach EFS to the ECS task
**Creating task running with the EFS volume attach with**

#Add following variable in ```ECS module``` 

        volume = [{
          name                             = "tapestry"
          efs_volume_configuration = [{
            file_system_id                 = <efs-filesystem-id>
            root_directory                 = "/"
            transit_encryption             = "ENABLED"
        }]
        }]
        container_mountPoints  = [{
          "containerPath": "/path_in_container/"
          "sourceVolume" : "tapestry"
        }]
    
> __Note:__  sourceVolume in container_mountpoint and name of the volume must be the same.

> __Note:__  you can attach the multiple volume to the container.

# Requirements

* [Terraform](https://www.terraform.io/)
* [GIT](https://git-scm.com/download/win)
* [AWS-Account](https://https://aws.amazon.com/)


# Recommended

* [Terraform for VSCode](https://github.com/mauve/vscode-terraform)
* [Terraform Config Inspect](https://github.com/hashicorp/terraform-config-inspect)
