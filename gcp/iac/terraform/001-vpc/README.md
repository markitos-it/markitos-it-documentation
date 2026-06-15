<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.10 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 5.0 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | ~> 5.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_google"></a> [google](#provider\_google) | ~> 5.0 |
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | ~> 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [google-beta_google_compute_global_address.private_ip_address](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_compute_global_address) | resource |
| [google-beta_google_service_networking_connection.private_vpc_connection](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_service_networking_connection) | resource |
| [google_compute_network.vpc](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network) | resource |
| [google_compute_router.router](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router) | resource |
| [google_compute_router_nat.nat](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router_nat) | resource |
| [google_compute_subnetwork.subnet](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork) | resource |
| [google_project_service.servicenetworking_api](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | ID del proyecto de GCP | `string` | `"markitosit-labs"` | no |
| <a name="input_region"></a> [region](#input\_region) | Región de GCP | `string` | `"europe-southwest1"` | no |
| <a name="input_subnet_cidr"></a> [subnet\_cidr](#input\_subnet\_cidr) | CIDR de la subred | `string` | `"10.0.0.0/24"` | no |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | Nombre de la subred | `string` | `"markitos-it-labs-vpc-subnet"` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Nombre de la VPC | `string` | `"markitos-it-labs-vpc"` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_subnet_id"></a> [subnet\_id](#output\_subnet\_id) | ID de la subred |
| <a name="output_subnet_name"></a> [subnet\_name](#output\_subnet\_name) | Nombre de la subred |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | ID de la VPC creada |
| <a name="output_vpc_name"></a> [vpc\_name](#output\_vpc\_name) | Nombre de la VPC |
<!-- END_TF_DOCS -->