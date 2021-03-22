locals {
  labels = merge(var.labels, {
    orchestrator = "terraform"
  })
}
