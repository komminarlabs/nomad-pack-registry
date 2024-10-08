job "influxdb2" {
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

  group "influxdb2" {
    count = 1

    network {
      port "http" {
        static = 8086
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

    [[- if var "config_volume.name" . ]]

    volume "[[ var "config_volume.name" . ]]" {
      type      = "[[ var "config_volume.type" . ]]"
      read_only = false
      source    = "[[ var "config_volume.name" . ]]"
    }
    [[- end ]]

    [[- if var "data_volume.name" . ]]

    volume "[[ var "data_volume.name" . ]]" {
      type      = "[[ var "data_volume.type" . ]]"
      read_only = false
      source    = "[[ var "data_volume.name" . ]]"
    }
    [[- end ]]

    restart {
      attempts = 2
      interval = "30m"
      delay    = "15s"
      mode     = "fail"
    }

    [[- if var "data_volume.name" . ]]

    task "chown_data_volume" {
      driver = "docker"

      lifecycle {
        hook    = "prestart"
        sidecar = false
      }

      volume_mount {
        volume      = "[[ var "data_volume.name" . ]]"
        destination = "/var/lib/influxdb2"
        read_only   = false
      }

      config {
        image   = "busybox:stable"
        command = "sh"
        args    = ["-c", "chown -R 1000:1000 /var/lib/influxdb2"]
      }

      resources {
        cpu    = 200
        memory = 128
      }
    }
    [[- end ]]

    [[- if var "config_volume.name" . ]]

    task "chown_config_volume" {
      driver = "docker"
      user   = "root"

      lifecycle {
        hook    = "prestart"
        sidecar = false
      }

      volume_mount {
        volume      = "[[ var "config_volume.name" . ]]"
        destination = "/etc/influxdb2"
        read_only   = false
      }
      
      config {
        image   = "busybox:stable"
        command = "sh"
        args    = ["-c", "chown -R 1000:1000 /etc/influxdb2"]
      }

      resources {
        cpu    = 200
        memory = 128
      }
    }
    [[- end ]]

    task "influxdb2" {
      driver = "docker"

      [[- if var "data_volume.name" . ]]

      volume_mount {
        volume      = "[[ var "data_volume.name" . ]]"
        destination = "/var/lib/influxdb2"
        read_only   = false
      }
      [[- end ]]

      [[- if var "config_volume.name" . ]]

      volume_mount {
        volume      = "[[ var "config_volume.name" . ]]"
        destination = "/etc/influxdb2"
        read_only   = false
      }
      [[- end ]]

      config {
        image = "influxdb:[[ var "influxdb2_version_tag" . ]]"
        ports = ["http"]
      }

      resources {
        cpu    = [[ var "task_resources.cpu" . ]]
        memory = [[ var "task_resources.memory" . ]]
      }

      [[- if ne (len (var "docker_env_vars" .)) 0 ]]

      env {
        [[- range $key, $var := var "docker_env_vars" . ]]
        [[if ne (len $var) 0 ]][[ $key | upper ]] = [[ $var | quote ]][[ end ]]
        [[- end ]]
      }
      [[- end ]]
    }
  }
}
