variable "config_volume" {
  description = "The dedicated config volume you want InfluxDB to use."
  type = object({
    name = string
    type = string
  })
}

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
  description = "The consul service for influxdb2."
  type = object({
    name     = string
    register = bool
    tags     = list(string)
  })
  default = {
    name     = "influxdb2",
    register = true,
    tags     = [],
  }
}

variable "datacenters" {
  description = "A list of datacenters in the region which are eligible for task placement."
  type        = list(string)
  default     = ["dc1"]
}

variable "data_volume" {
  description = "The dedicated data volume you want InfluxDB to use."
  type = object({
    name = string
    type = string
  })
}

variable "docker_env_vars" {
  type        = map(string)
  description = "Environment variables to pass to Docker container."
  default     = {}
}

variable "influxdb2_version_tag" {
  description = "The docker image tag."
  type        = string
  default     = "2.7.10"
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

variable "task_resources" {
  description = "Resources used by InfluxDB task."
  type = object({
    cpu    = number
    memory = number
  })
  default = {
    cpu    = 500,
    memory = 256,
  }
}

variable "region" {
  description = "The region where jobs will be deployed."
  type        = string
  default     = "global"
}
