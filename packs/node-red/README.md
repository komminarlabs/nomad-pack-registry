# Node-RED

This pack uses Docker driver to deploy Node-RED in Nomad.

## Variables

- `docker_env_vars` (map of string) - Environment variables to pass to Docker container.
- `node_pool` (string) - The node_pool where the job should be placed.
- `nodered_task_resources` (object) - The resource to assign to the Node-RED service task.
- `constraints` (list of object) - Constraints to apply to the entire job.
- `data_volume` (object) - The dedicated data volume you want Node-RED to use.
- `namespace` (string) - The namespace where the job should be placed.
- `nodered_version_tag` (string) - The docker image version.
- `region` (string) - The region where the job should be placed.
- `consul_service` (object) - The consul service for Node-RED.
- `datacenters` (list of string) - A list of datacenters in the region which are eligible for task placement.
