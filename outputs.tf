output "ip_address" {
  value = google_compute_global_forwarding_rule.lb_http_forwarding_rule.ip_address
}
