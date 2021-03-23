# Terraform google Cortex Module

Terraform module for setting up [cortex](cortexmetrics.io) on Kubernetes with block storage configs.
It also sets up minimal consul deployment needed for cortex as KV store for the HA tracker.
This module is using following [cortex-helm-chart](https://github.com/cortexproject/cortex-helm-chart)

## Compatibility

This module is meant for use with Terraform 0.12.

## Dependencies

- helm >= 3.0

## Example Usage

```
module "cortex_app" {
  source                          = "git::https://github.com/odif/terraform-google-cortex.git"
  project_name                    = "gcp-project"
  region                          = "asia-southeast-1"
  namespace                       = "cortex"
  network_name                    = "my-vpc"
  aws_zone_id                     = "XXXX"
  ingress_dns                     = "example.com"
  load_balancer_ingress_name      = "ingress"
  load_balancer_ingress_namespace = "infra"
  consul_helm_values_override     = file("${path.module}/example_consul.yaml")
  cortex_helm_values_override     = file("${path.module}/example_cortex.yaml")
}
```

## Providers

| Name        | Version |
| ----------- | ------- |
| google      | ~> 3.0  |
| google-beta | ~> 3.0  |
| helm        | >=2.0   |
| kubernetes  | n/a     |
| aws         | n/a     |

## Inputs

| Name                            | Description                                                                                                           | Type     | Default    | Required |
| ------------------------------- | --------------------------------------------------------------------------------------------------------------------- | -------- | ---------- | :------: |
| app_name                        | n/a                                                                                                                   | `string` | `"cortex"` |    no    |
| aws_zone_id                     | AWS DNS zone Id for ingress creation                                                                                  | `string` | n/a        |   yes    |
| consul_helm_values_override     | String in yaml format to override helm values for consul. Ref: https://github.com/odpf/charts/tree/main/stable/consul | `string` | `""`       |    no    |
| cortex_helm_values_override     | String in yaml format to override helm values for cortex. Ref: https://github.com/cortexproject/cortex-helm-chart     | `string` | `""`       |    no    |
| ingress_dns                     | Domain name for ingress                                                                                               | `string` | n/a        |   yes    |
| ingress_enabled                 | n/a                                                                                                                   | `bool`   | `true`     |    no    |
| labels                          | n/a                                                                                                                   | `map`    | `{}`       |    no    |
| load_balancer_ingress_name      | Loadbalancer ingress service name for kubernetes_service data resource                                                | `string` | n/a        |   yes    |
| load_balancer_ingress_namespace | Loadbalancer ingress service namespace for kubernetes_service data resource                                           | `any`    | n/a        |   yes    |
| namespace                       | n/a                                                                                                                   | `string` | `"cortex"` |    no    |
| network_name                    | GCP Network name                                                                                                      | `string` | n/a        |   yes    |
| project_name                    | GCP Project name                                                                                                      | `string` | n/a        |   yes    |
| region                          | GCP Network region/location. eg: asia-southeast1                                                                      | `string` | n/a        |   yes    |

## Outputs

| Name     | Description                          |
| -------- | ------------------------------------ |
| bucket   | GCS Bucket details for block storage |
| memcache | GCP memory store details             |

## Requirements

### Installed Software

- [Terraform](https://www.terraform.io/downloads.html) ~> 0.12.6
- [Terraform Provider for GCP](https://github.com/terraform-providers/terraform-provider-google) ~> 3.0
- [Terraform Provider for GCP Beta](https://github.com/terraform-providers/terraform-provider-google-beta) ~>
  3.0

### Enable API's

In order to operate with it you must activate the following API on the same project:

- Cloud Memorystore for Memcached API - memcache.googleapis.com
