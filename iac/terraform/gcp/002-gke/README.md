<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 5.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_google"></a> [google](#provider\_google) | ~> 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [google_container_cluster.autopilot_cluster](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster) | resource |
| [google_project_service.container_api](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the GKE Autopilot cluster | `string` | `"markitos-it-cluster"` | no |
| <a name="input_master_ipv4_cidr_block"></a> [master\_ipv4\_cidr\_block](#input\_master\_ipv4\_cidr\_block) | The IP range in CIDR notation to use for the hosted master network. Must be a /28 subnet. | `string` | `"172.16.0.0/28"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | ID del proyecto de GCP | `string` | `"markitosit-labs"` | no |
| <a name="input_region"></a> [region](#input\_region) | Región de GCP | `string` | `"europe-southwest1"` | no |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | The name of the subnetwork | `string` | `"markitos-it-vpc-subnet"` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Nombre de la VPC | `string` | `"markitos-it-labs-vpc"` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_cluster_ca_certificate"></a> [cluster\_ca\_certificate](#output\_cluster\_ca\_certificate) | The base64 encoded public certificate of the cluster |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | The IP address of the cluster master |
| <a name="output_cluster_location"></a> [cluster\_location](#output\_cluster\_location) | The location of the GKE cluster |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | The name of the GKE cluster |
<!-- END_TF_DOCS -->