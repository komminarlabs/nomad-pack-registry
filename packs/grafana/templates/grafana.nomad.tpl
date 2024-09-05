job "grafana" {
  region      = "[[ var "region" . ]]"
  datacenters = [[ (var "datacenters" .) | toStringList ]]
  node_pool   = "[[ var "node_pool" . ]]"
  type        = "service"
  [[- if var "namespace" . ]]
  namespace   = "[[ var "namespace" . ]]"
  [[- end ]]

  [[- if var "constraints" . ]][[ range $idx, $constraint := var "constraints" . ]]
  
  constraint {
    [[- if ne $constraint.attribute "" ]]
    attribute = "[[ $constraint.attribute ]]"
    [[- end ]]
    [[- if ne $constraint.value "" ]]
    value = "[[ $constraint.value ]]"
    [[- end ]]
    [[- if ne $constraint.operator "" ]]
    operator = "[[ $constraint.operator ]]"
    [[- end ]]
  }
  [[- end ]]
  [[- end ]]

  group "grafana" {
    count = 1

    network {
      port "http" {
        static = 3000
      }
    }

    [[- if var "consul_service.register" . ]]
    
    service {
      name = "[[ var "consul_service.name" . ]]"
      [[- if ne (len (var "consul_service.tags" .)) 0 ]]
      tags = [[ (var "consul_service.tags" .) | toStringList ]]
      [[- end ]]
      port = "http"

      check {
        name     = "alive"
        type     = "http"
        path     = "/health"
        interval = "10s"
        timeout  = "2s"
      }
    }
    [[- end ]]

    [[- if var "vault_policies" . ]]

    vault {
      policies    = [[ (var "vault_policies" .) | toStringList ]]
      change_mode = "noop"
    }
    [[- end ]]

    [[- if var "data_volume" . ]]
    volume "[[ var "data_volume.name" . ]]" {
      type      = "[[ var "data_volume.type" . ]]"
      read_only = false
      source    = "[[ var "data_volume.name" . ]]"
    }
    [[- end ]]

    [[- if var "data_volume" . ]]

    task "chown_data_volume" {
      driver = "docker"

      lifecycle {
        hook    = "prestart"
        sidecar = false
      }

      volume_mount {
        volume      = "[[ var "data_volume.name" . ]]"
        destination = "/var/lib/grafana"
        read_only   = false
      }

      config {
        image   = "busybox:stable"
        command = "sh"
        args    = ["-c", "chown -R 1000:1000 /var/lib/grafana"]
      }

      resources {
        cpu    = 200
        memory = 128
      }
    }
    [[- end ]]

    task "grafana" {
      driver = "docker"

      [[- if var "data_volume" . ]]

      volume_mount {
        volume      = "[[ var "data_volume.name" . ]]"
        destination = "/var/lib/grafana"
        read_only   = false
      }
      [[- end ]]

      config {
        image = "grafana/grafana:[[ var "grafana_version_tag" . ]]"
        ports = ["http"]
      }

      resources {
        cpu    = [[ var "grafana_task_resources.cpu" . ]]
        memory = [[ var "grafana_task_resources.memory" . ]]
      }

      [[- if ne (len (var "docker_env_vars" .)) 0 ]]

      env {
        [[- range $key, $var := var "docker_env_vars" . ]]
        [[if ne (len $var) 0 ]][[ $key | upper ]] = [[ $var | quote ]][[ end ]]
        [[- end ]]
      }
      [[- end ]]

      [[- if var "grafana_task_artifacts" . ]]
      [[- range $artifact := var "grafana_task_artifacts" . ]]

      artifact {
        source      = "[[ $artifact.source ]]"
        destination = "[[ $artifact.destination ]]"
        mode        = "[[ $artifact.mode ]]"
        [[- if $artifact.options ]]
        options {
          [[- range $option, $val := $artifact.options ]]
          [[ $option ]] = "[[ $val ]]"
          [[- end ]]
        }
        [[- end ]]
      }
      [[- end ]]
      [[- end ]]

      template {
        data        = <<EOF
[[ var "grafana_task_config_ini" . ]]
EOF
        destination = "/local/grafana/grafana.ini"
      }

      [[- if var "grafana_task_config_dashboards" . ]]
      template {
        data        = <<EOF
[[ var "grafana_task_config_dashboards" . ]]
EOF
        destination = "/local/grafana/provisioning/dashboards/dashboards.yaml"
      }
      [[ end ]]

      [[- if var "grafana_task_config_datasources" . ]]
      template {
        data        = <<EOF
[[ var "grafana_task_config_datasources" . ]]
EOF
        destination = "/local/grafana/provisioning/datasources/datasources.yaml"
      }
      [[ end ]]

      [[- if var "grafana_task_config_plugins" . ]]

      template {
        data        = <<EOF
[[ var "grafana_task_config_plugins" . ]]
EOF
        destination = "/local/grafana/provisioning/plugins/plugins.yml"
      }
      [[- end -]]
    }
  }
}
