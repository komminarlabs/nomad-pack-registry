config_volume_name      = "config_volume"
data_volume_name        = "data_volume"
register_consul_service = false

docker_influxdb2_env_vars = {
  "docker_influxdb_init_mode" : "setup",
  "docker_influxdb_init_username" : "my-user",
  "docker_influxdb_init_password" : "my-password",
  "docker_influxdb_init_org" : "my-org",
  "docker_influxdb_init_bucket" : "my-bucket",
  "docker_influxdb_init_retention" : "1w",
  "docker_influxdb_init_admin_token" : "my-super-secret-auth-token",
}
