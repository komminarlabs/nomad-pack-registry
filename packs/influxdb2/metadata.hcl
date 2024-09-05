app {
  url    = "https://www.influxdata.com/"
  author = "InfluxData"
}

pack {
  name        = "influxdb2"
  description = "InfluxDB is the platform purpose-built to collect, store, process and visualize time series data."
  url         = "https://github.com/komminarlabs/nomad-pack-registry/influxdb2"
  version     = "0.1.0"
}

integration {
  identifier = "nomad/komminarlabs/influxdb2"
  name       = "InfluxDB OSS"
}
