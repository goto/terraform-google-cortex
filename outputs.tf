output "data_bucket" {
  value       = google_storage_bucket.cortex_data
  description = "GCS Bucket details for block storage"
}

output "config_bucket" {
  value       = google_storage_bucket.cortex_configs
  description = "GCS Bucket details for configs"
}

output "memcache" {
  value       = google_memcache_instance.cortex
  description = "GCP memory store details"
}

output "ingress_dns" {
  description = "DNS zone record details for ingress"
  value = (var.ingress_enabled)? aws_route53_record.dns_ingress[0] : null
}
