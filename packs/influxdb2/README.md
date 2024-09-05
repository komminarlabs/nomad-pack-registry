# InfluxDB OSS

This pack uses Docker driver to deploy InfluxDB OSS in Nomad.

## Variables

- `config_volume_name` (string) - The name of the dedicated config volume you want InfluxDB to use.
- `config_volume_type` (string) - The type of the dedicated config volume you want InfluxDB to use.
- `constraints` (list of object) - Constraints to apply to the entire job.
- `consul_service_name` (string) - The consul service name for the application.
- `consul_service_tags` (list of string) - The consul service name for the application.
- `datacenters` (list of string) - A list of datacenters in the region which are eligible for task placement.
- `data_volume_name` (string) - The name of the dedicated data volume you want InfluxDB to use.
- `data_volume_type` (string) - The type of the dedicated data volume you want InfluxDB to use.
- `docker_influxdb2_env_vars` (map of string) - Environment variables to pass to Docker container.
- `image_tag` (string) - The docker image tag.
- `namespace` (string) - The namespace where the job should be placed.
- `node_pool` (string) - The node_pool where the job should be placed.
- `region` (string) - The region where jobs will be deployed.
- `register_consul_service` (bool) - If you want to register a consul service for the job.
- `task_resources` (object) - Resources used by InfluxDB task.

## Automated Setup

If you pass the right environment variables to the pack, you can automatically setup the init of InfluxDB OSS. An example of the `docker_influxdb2_env_vars` to use is in the `overrides.hcl` file.
