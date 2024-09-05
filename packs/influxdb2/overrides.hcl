config_volume_name      = "config_volume"
data_volume_name        = "data_volume"
register_consul_service = true

docker_influxdb2_env_vars = {
  "docker_influxdb_init_mode" : "setup",
  "docker_influxdb_init_username" : "username",
  "docker_influxdb_init_password" : "password",
  "docker_influxdb_init_org" : "org",
  "docker_influxdb_init_bucket" : "bucket",
  "docker_influxdb_init_retention" : "1w",
  "docker_influxdb_init_admin_token" : "supersecrettoken12345",
}
