app {
  url    = "https://grafana.com/"
  author = "Grafana Labs"
}

pack {
  name        = "grafana"
  description = "Dashboard anything. Observe everything."
  url         = "https://github.com/komminarlabs/nomad-pack-registry/grafana"
  version     = "0.1.0"
}

integration {
  identifier = "nomad/komminarlabs/grafana"
  name       = "Grafana OSS"
}
