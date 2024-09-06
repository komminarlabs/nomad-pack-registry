job "node-red" {
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

  group "node-red" {
    count = 1

    network {
      port "http" {
        static = 1880
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
        type     = "tcp"
        interval = "10s"
        timeout  = "2s"
      }
    }
    [[- end ]]

    [[- if var "data_volume" . ]]
    volume "[[ var "data_volume.name" . ]]" {
      type      = "[[ var "data_volume.type" . ]]"
      read_only = false
      source    = "[[ var "data_volume.name" . ]]"
    }
    [[- end ]]

    task "node-red" {
      driver = "docker"

      [[- if var "data_volume" . ]]

      volume_mount {
        volume      = "[[ var "data_volume.name" . ]]"
        destination = "/data"
        read_only   = false
      }
      [[- end ]]

      config {
        image = "nodered/node-red:[[ var "nodered_version_tag" . ]]"
        ports = ["http"]
      }

      resources {
        cpu    = [[ var "nodered_task_resources.cpu" . ]]
        memory = [[ var "nodered_task_resources.memory" . ]]
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
