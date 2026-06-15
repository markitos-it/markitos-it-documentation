<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.12.2 |
| <a name="requirement_google"></a> [google](#requirement\_google) | 6.41.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.4.3 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | 3.4.3 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [null_resource.hello_world_echo](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_string.resource_unique_suffix](https://registry.terraform.io/providers/hashicorp/random/3.4.3/docs/resources/string) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_credentials_file_path"></a> [credentials\_file\_path](#input\_credentials\_file\_path) | Relative path to the GCP service account credentials JSON file from project root | `string` | `"./key.json"` | no |
| <a name="input_deployment_region"></a> [deployment\_region](#input\_deployment\_region) | Google Cloud Platform region where resources will be deployed | `string` | `"us-central1"` | no |
| <a name="input_deployment_zone"></a> [deployment\_zone](#input\_deployment\_zone) | Google Cloud Platform availability zone within the specified region | `string` | `"us-central1-a"` | no |
| <a name="input_environment_target"></a> [environment\_target](#input\_environment\_target) | Current target environment for resource deployment (required) | `string` | n/a | yes |
| <a name="input_group_category"></a> [group\_category](#input\_group\_category) | Category or functional area of the resource group being deployed (required) | `string` | n/a | yes |
| <a name="input_project_identifier"></a> [project\_identifier](#input\_project\_identifier) | Google Cloud Platform project unique identifier | `string` | `"terraform-markitos"` | no |
| <a name="input_resource_creator_information"></a> [resource\_creator\_information](#input\_resource\_creator\_information) | Information about the creator of the infrastructure resources | `string` | `"Marco Antonio - markitos - DevsecopsKulture"` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_deployment_region"></a> [deployment\_region](#output\_deployment\_region) | Google Cloud Platform region where resources are deployed |
| <a name="output_environment_deployment_target"></a> [environment\_deployment\_target](#output\_environment\_deployment\_target) | The target environment where resources are deployed |
| <a name="output_group_category"></a> [group\_category](#output\_group\_category) | Category or functional area of the resource group being deployed |
| <a name="output_project_identifier"></a> [project\_identifier](#output\_project\_identifier) | Google Cloud Platform project identifier used for resource deployment |
| <a name="output_resource_creator_information"></a> [resource\_creator\_information](#output\_resource\_creator\_information) | Information about the creator of the infrastructure resources |
| <a name="output_resource_unique_suffix"></a> [resource\_unique\_suffix](#output\_resource\_unique\_suffix) | Unique suffix generated for resource naming to avoid conflicts |
| <a name="output_standardized_resource_tags"></a> [standardized\_resource\_tags](#output\_standardized\_resource\_tags) | Standardized tags applied to all resources for consistent labeling |
<!-- END_TF_DOCS -->