variable "app_name" {
  default = "cortex"
  type    = string
}

variable "project_name" {
  description = "GCP Project name"
  type        = string
}

variable "network_name" {
  description = "GCP Network name"
  type        = string
}

variable "region" {
  description = "GCP Network region/location. eg: asia-southeast1"
  type        = string
}
variable "namespace" {
  default = "cortex"
  type    = string
}

variable "aws_zone_id" {
  description = "AWS DNS zone Id for ingress creation"
  type        = string
}

variable "labels" {
  type    = map
  default = {}
}

variable "ingress_enabled" {
  type    = bool
  default = true
}

variable "ingress_dns" {
  type        = string
  description = "Domain name for ingress"
}

variable "load_balancer_ingress_name" {
  type        = string
  description = "Loadbalancer ingress service name for kubernetes_service data resource"
}

variable "load_balancer_ingress_namespace" {
  description = "Loadbalancer ingress service namespace for kubernetes_service data resource"
}

variable "consul_helm_release_config" {
  default = {
    wait            = true,
    timeout         = 150,
    repository      = "https://odpf.github.io/charts"
    chart           = "consul"
    version         = "0.1.0"
    values_override = "" ## String in yaml format to override helm values for consul. Ref: https://github.com/odpf/charts/tree/main/stable/consul
  }
  description = "Configs mapped to terraform helm_release provider. Ref:https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release"
}

variable "cortex_helm_release_config" {
  default = {
    wait            = true,
    timeout         = 600,
    repository      = "https://cortexproject.github.io/cortex-helm-chart",
    chart           = "cortex",
    version         = "0.4.0",
    values_override = "" ## String in yaml format to override helm values for consul. Ref: https://github.com/odpf/charts/tree/main/stable/consul
  }
  description = "Configs mapped to terraform helm_release provider. Ref:https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release"
}

variable "memcached_config" {
  default = {
    node_count = 1
    node_config = {
      cpu_count = 1
      memory_size_mb = 1024
    }
  }
  description = "Configs for the GCP memorystore memcached cluster"
}
