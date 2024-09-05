variable "config_volume_name" {
  description = "The name of the dedicated config volume you want InfluxDB to use."
  type        = string
}

variable "config_volume_type" {
  description = "The type of the dedicated config volume you want InfluxDB to use."
  type        = string
  default     = "host"
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

variable "consul_service_name" {
  description = "The consul service name for the application."
  type        = string
  default     = "influxdb2"
}

variable "consul_service_tags" {
  description = "The consul service name for the application."
  type        = list(string)
  default     = []
}

variable "datacenters" {
  description = "A list of datacenters in the region which are eligible for task placement."
  type        = list(string)
  default     = ["dc1"]
}

variable "data_volume_name" {
  description = "The name of the dedicated data volume you want InfluxDB to use."
  type        = string
}

variable "data_volume_type" {
  description = "The type of the dedicated data volume you want InfluxDB to use."
  type        = string
  default     = "host"
}

variable "docker_influxdb2_env_vars" {
  type        = map(string)
  description = "Environment variables to pass to Docker container."
  default     = {}
}

variable "image_tag" {
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

variable "region" {
  description = "The region where jobs will be deployed."
  type        = string
  default     = "global"
}

variable "register_consul_service" {
  description = "If you want to register a consul service for the job."
  type        = bool
  default     = false
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
