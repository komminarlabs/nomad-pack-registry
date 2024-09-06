variable "constraints" {
  description = "Constraints to apply to the entire job."
  type = list(object({
    attribute = string
    operator  = string
    value     = string
  }))
  default = [
    {
      attribute = "$${attr.kernel.name}",
      value     = "(linux|darwin)",
      operator  = "regexp",
    },
  ]
}

variable "consul_service" {
  description = "The consul service for Node-RED."
  type = object({
    name     = string
    register = bool
    tags     = list(string)
  })
  default = {
    name     = "nodered",
    register = true,
    tags     = [],
  }
}

variable "data_volume" {
  description = "The dedicated data volume you want Node-RED to use."
  type = object({
    type   = string
    source = string
  })
}

variable "datacenters" {
  description = "A list of datacenters in the region which are eligible for task placement."
  type        = list(string)
  default     = ["dc1"]
}

variable "docker_env_vars" {
  type        = map(string)
  description = "Environment variables to pass to Docker container."
  default     = {}
}

variable "namespace" {
  description = "The namespace where the job should be placed."
  type        = string
  default     = "default"
}

variable "node_pool" {
  description = "The node_pool where the job should be placed."
  type        = string
  default     = "default"
}

variable "nodered_task_resources" {
  description = "The resource to assign to the Node-RED service task."
  type = object({
    cpu    = number
    memory = number
  })
  default = {
    cpu    = 500,
    memory = 256,
  }
}

variable "nodered_version_tag" {
  description = "The docker image version."
  type        = string
  default     = "4.0.2-22"
}

variable "region" {
  description = "The region where the job should be placed."
  type        = string
  default     = "global"
}
