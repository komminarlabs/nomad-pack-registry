data_volume = {
  name = "influxdb2_data_volume"
  type = "host"
}

config_volume = {
  name = "influxdb2_config_volume"
  type = "host"
}

docker_env_vars = {
  "DOCKER_INFLUXDB_INIT_MODE" : "setup",
  "DOCKER_INFLUXDB_INIT_USERNAME" : "username",
  "DOCKER_INFLUXDB_INIT_PASSWORD" : "password",
  "DOCKER_INFLUXDB_INIT_ORG" : "org",
  "DOCKER_INFLUXDB_INIT_BUCKET" : "bucket",
  "DOCKER_INFLUXDB_INIT_RETENTION" : "1w",
  "DOCKER_INFLUXDB_INIT_ADMIN_TOKEN" : "supersecrettoken12345",
}
