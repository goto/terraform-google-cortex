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

variable "cluster_name" {
  description = "Kubernetes cluster name to deploy cortex"
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