output "bucket" {
  value       = google_storage_bucket.cortex
  description = "GCS Bucket details for block storage"
}

output "memcache" {
  value       = google_memcache_instance.cortex
  description = "GCP memory store details"
}

output "ingress_dns" {
  value = (var.ingress_enabled)? aws_route53_record.dns_ingress[0] : null
}
