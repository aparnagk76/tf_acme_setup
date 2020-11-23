# tf_acme_setup

## Requirements

| Name | Version |
|------|---------|
| aws | ~> 3.0 |

## Providers

No provider.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| backend\_instance\_count | the count of backend ec2 instances | `number` | `3` | no |
| egress\_cidr\_blocks | list of cidr blocks to allow outgoing traffic | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| environment\_name | the name of an environment | `string` | `"acme-dev"` | no |
| ingress\_cidr\_blocks | list of cidr blocks to allow incoming traffic | `list(string)` | <pre>[<br>  "67.169.175.5/32",<br>  "10.2.1.0/24"<br>]</pre> | no |
| instance\_type | the type of ec2 instance | `string` | `"t2.micro"` | no |
| vpc\_cidr\_block | vpc cidr\_block | `string` | `"10.2.0.0/16"` | no |

## Outputs

No output.

