# Grafana OSS

This pack uses Docker driver to deploy Grafana OSS in Nomad.

## Variables

- `datacenters` (list of string) - A list of datacenters in the region which are eligible for task placement.
- `docker_env_vars` (map of string) - Environment variables to pass to Docker container.
- `grafana_task_config_datasources` (string) - The yaml configuration for automatic provision of datasources.
- `grafana_task_config_ini` (string) - ini string for grafana.ini.
- `grafana_task_resources` (object) - The resource to assign to the Grafana service task.
- `region` (string) - The region where the job should be placed.
- `constraints` (list of object) - Constraints to apply to the entire job.
- `consul_service` (object) - The consul service for grafana.
- `data_volume` (object) - The dedicated data volume you want InfluxDB to use.
- `grafana_task_artifacts` (list of object) - Define external artifacts for Grafana.
- `grafana_task_config_dashboards` (string) - The yaml configuration for automatic provision of dashboards.
- `grafana_version_tag` (string) - The docker image version. For options, see https://hub.docker.com/grafana/grafana.
- `grafana_task_config_plugins` (string) - The yaml configuration for automatic provision of plugins.
- `namespace` (string) - The namespace where the job should be placed.
- `node_pool` (string) - The node_pool where the job should be placed.
- `vault_policies` (list of string) - List of Vault Policies.
