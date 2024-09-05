# InfluxDB OSS

This pack uses Docker driver to deploy InfluxDB OSS in Nomad.

## Variables

- `data_volume` (object) - The dedicated data volume you want InfluxDB to use.
- `influxdb2_version_tag` (string) - The docker image tag.
- `namespace` (string) - The namespace where the job should be placed.
- `region` (string) - The region where jobs will be deployed.
- `config_volume` (object) - The dedicated config volume you want InfluxDB to use.
- `constraints` (list of object) - Constraints to apply to the entire job.
- `datacenters` (list of string) - A list of datacenters in the region which are eligible for task placement.
- `task_resources` (object) - Resources used by InfluxDB task.
- `consul_service` (object) - The consul service for influxdb2.
- `docker_env_vars` (map of string) - Environment variables to pass to Docker container.
- `node_pool` (string) - The node_pool where the job should be placed.

## Automated Setup

If you pass the right environment variables to the pack, you can automatically setup the init of InfluxDB OSS. An example of the `docker_influxdb2_env_vars` to use is in the `overrides.hcl` file.
