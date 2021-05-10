resource "google_storage_bucket" "cortex" {
  name          = var.app_name
  location      = "asia"
  project       = var.project_name
  storage_class = "MULTI_REGIONAL"
  labels        = merge(local.labels, { component = "bucket" })
}

resource "google_memcache_instance" "cortex" {
  provider           = google-beta
  name               = "${var.app_name}-memcache"
  region             = var.region
  authorized_network = "projects/${var.project_name}/global/networks/${var.network_name}"
  node_count         = 1
  memcache_version   = "MEMCACHE_1_5"
  node_config {
    cpu_count      = 1
    memory_size_mb = 1024
  }
  labels = merge(local.labels, { component = "memcache" })
}

resource "google_service_account" "service_account" {
  project    = var.project_name
  account_id = var.app_name
}

resource "google_service_account_key" "service_account_key" {
  service_account_id = google_service_account.service_account.name
}

resource "kubernetes_secret" "cortex-google-credentials" {
  metadata {
    name      = "${var.app_name}-google-credentials"
    namespace = var.namespace
    labels    = merge(var.labels, { app = var.app_name })
    annotations = {
      "kubernetes.io/service-account.name" = "${var.app_name}-google-credentials"
    }
  }

  data = {
    "gcs.json" = base64decode(google_service_account_key.service_account_key.private_key)
  }

  depends_on = [
    helm_release.consul,
  ]

  type = "Opaque"
}

resource "google_storage_bucket_iam_member" "buckets_access" {
  bucket = google_storage_bucket.cortex.name
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.service_account.email}"
}

resource "helm_release" "consul" {
  name             = "${var.app_name}-consul"
  namespace        = var.namespace
  create_namespace = true
  repository       = var.consul_helm_release_config.repository
  chart            = var.consul_helm_release_config.chart
  version          = var.consul_helm_release_config.version
  wait             = var.consul_helm_release_config.wait
  timeout          = var.consul_helm_release_config.timeout
  values = [
    templatefile("${path.module}/templates/consul.yaml", {
      "labels" = jsonencode(local.labels)
    }),
    var.consul_helm_release_config.values_override
  ]
}

resource "helm_release" "cortex" {
  name              = var.app_name
  namespace         = var.namespace
  repository        = var.cortex_helm_release_config.repository
  chart             = var.cortex_helm_release_config.chart
  version           = var.cortex_helm_release_config.version
  wait              = var.cortex_helm_release_config.wait
  timeout           = var.cortex_helm_release_config.timeout
  create_namespace  = true
  dependency_update = true
  values = [
    templatefile("${path.module}/templates/cortex.yaml", {
      memcached = {
        addresses = google_memcache_instance.cortex.discovery_endpoint
      }
      "gcs" = {
        "bucket_name" = google_storage_bucket.cortex.id
      },
      "consul" = {
        host = "${var.app_name}-consul.${var.namespace}.svc.cluster.local:8500"
      },
      "host_ingress" = var.ingress_dns
      "app_name"     = var.app_name
    }),
    var.cortex_helm_release_config.values_override
  ]

  depends_on = [
    kubernetes_secret.cortex-google-credentials,
  ]
}

resource "aws_route53_record" "dns_ingress" {
  count   = (var.ingress_enabled) ? 1 : 0
  zone_id = var.aws_zone_id
  name    = var.ingress_dns
  type    = "A"
  ttl     = "300"
  records = [data.kubernetes_service.cortex.load_balancer_ingress[0].ip]
}
