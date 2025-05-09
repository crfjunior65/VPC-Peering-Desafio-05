<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws.sao_paulo"></a> [aws.sao\_paulo](#provider\_aws.sao\_paulo) | 5.97.0 |
| <a name="provider_aws.virginia"></a> [aws.virginia](#provider\_aws.virginia) | 5.97.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc_sao_paulo"></a> [vpc\_sao\_paulo](#module\_vpc\_sao\_paulo) | terraform-aws-modules/vpc/aws | ~> 5.0 |
| <a name="module_vpc_virginia"></a> [vpc\_virginia](#module\_vpc\_virginia) | terraform-aws-modules/vpc/aws | ~> 5.0 |

## Resources

| Name | Type |
|------|------|
| [aws_instance.sao_paulo_ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_instance.virginia_ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_route.sao_paulo_public_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.virginia_public_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_security_group.sao_paulo_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.virginia_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_vpc_peering_connection.virginia_to_saopaulo](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection) | resource |
| [aws_vpc_peering_connection_accepter.saopaulo_accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_accepter) | resource |
| [aws_ami.amazon_linux_sao_paulo](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_ami.amazon_linux_virginia](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_sao_paulo_ec2_public_ip"></a> [sao\_paulo\_ec2\_public\_ip](#output\_sao\_paulo\_ec2\_public\_ip) | n/a |
| <a name="output_virginia_ec2_public_ip"></a> [virginia\_ec2\_public\_ip](#output\_virginia\_ec2\_public\_ip) | outputs.tf |
<!-- END_TF_DOCS -->
