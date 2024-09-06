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
  description = "The consul service for Grafana."
  type = object({
    name     = string
    register = bool
    tags     = list(string)
  })
  default = {
    name     = "grafana",
    register = true,
    tags     = [],
  }
}

variable "data_volume" {
  description = "The dedicated data volume you want Grafana to use."
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
  default = {
    "GF_LOG_LEVEL" : "DEBUG",
    "GF_LOG_MODE" : "console",
    "GF_SERVER_HTTP_PORT" : "$${NOMAD_PORT_http}",
    "GF_PATHS_PROVISIONING" : "/local/grafana/provisioning",
    "GF_PATHS_CONFIG" : "/local/grafana/grafana.ini",
  }
}

variable "grafana_task_artifacts" {
  description = "Define external artifacts for Grafana."
  type = list(object({
    source      = string
    destination = string
    mode        = string
    options     = map(string)
  }))
  default = [
    {
      source      = "https://grafana.com/api/dashboards/1860/revisions/26/download",
      destination = "local/grafana/provisioning/dashboards/linux/linux-node-exporter.json",
      mode        = "file",
      options     = null,
    },
  ]
}

variable "grafana_task_config_dashboards" {
  description = "The yaml configuration for automatic provision of dashboards."
  type        = string
  default     = <<EOF
apiVersion: 1

providers:
  - name: dashboards
    type: file
    updateIntervalSeconds: 30
    options:
      foldersFromFilesStructure: true
      path: /local/grafana/provisioning/dashboards
EOF
}

variable "grafana_task_config_datasources" {
  description = "The yaml configuration for automatic provision of datasources."
  type        = string
  default     = <<EOF
apiVersion: 1
datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://prometheus.service.{{ env "NOMAD_DC" }}.consul:9090
    jsonData:
      exemplarTraceIdDestinations:
        - name: traceID
          datasourceUid: tempo
  - name: Tempo
    type: tempo
    access: proxy
    url: http://tempo.service.{{ env "NOMAD_DC" }}.consul:3200
    uid: tempo
  - name: Loki
    type: loki
    access: proxy
    url: http://loki.service.{{ env "NOMAD_DC" }}.consul:3100
    jsonData:
      derivedFields:
        - datasourceUid: tempo
          matcherRegex: (?:traceID|trace_id)=(\w+)
          name: TraceID
          url: $$${__value.raw}
EOF
}

variable "grafana_task_config_ini" {
  description = "ini string for grafana.ini."
  type        = string
  default     = ""
}

variable "grafana_task_config_plugins" {
  description = "The yaml configuration for automatic provision of plugins."
  type        = string
}

variable "grafana_task_resources" {
  description = "The resource to assign to the Grafana service task."
  type = object({
    cpu    = number
    memory = number
  })
  default = {
    cpu    = 200,
    memory = 256,
  }
}

variable "grafana_version_tag" {
  description = "The docker image version. For options, see https://hub.docker.com/grafana/grafana."
  type        = string
  default     = "latest"
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
  description = "The region where the job should be placed."
  type        = string
  default     = "global"
}

variable "vault_policies" {
  description = "List of Vault Policies."
  type        = list(string)
  default     = []
}
