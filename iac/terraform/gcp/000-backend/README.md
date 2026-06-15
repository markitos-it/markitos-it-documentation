<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.10 |
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
| [google_storage_bucket.terraform_state](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Nombre del bucket para el estado de Terraform | `string` | `"markitos-it-portfolio-tfstates"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | ID del proyecto de GCP | `string` | `"markitosit-labs"` | no |
| <a name="input_region"></a> [region](#input\_region) | Región de GCP | `string` | `"europe-southwest1"` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_bucket_name"></a> [bucket\_name](#output\_bucket\_name) | Nombre del bucket creado para el estado de Terraform |
| <a name="output_bucket_url"></a> [bucket\_url](#output\_bucket\_url) | URL del bucket |
<!-- END_TF_DOCS -->