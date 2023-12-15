locals {
  redirect_http_to_https = var.redirect_http_to_https == true && var.ssl_certificate_enabled == true
}

resource "google_compute_backend_service" "lb_backend" {
  name = var.name

  port_name        = var.instance_group_named_port_http
  protocol         = "HTTP"
  timeout_sec      = 60
  session_affinity = "NONE"

  backend {
    group = var.instance_group_url
  }

  health_checks = [var.health_check_self_link]
}

resource "google_compute_url_map" "lb_url_map" {
  name = var.name

  default_service = google_compute_backend_service.lb_backend.self_link
}

resource "google_compute_target_http_proxy" "lb_target_http_proxy" {
  name = "${var.name}-http-proxy"

  url_map = local.redirect_http_to_https ? google_compute_url_map.http_to_https_redirect[0].self_link : google_compute_url_map.lb_url_map.self_link
}

resource "google_compute_ssl_policy" "lb_target_https_ssl_policy" {
  count = var.ssl_certificate_enabled ? 1 : 0

  name            = "${var.name}-https-ssl-policy"
  profile         = var.ssl_profile
  min_tls_version = var.ssl_min_tls_version
}

resource "google_compute_target_https_proxy" "lb_target_https_proxy" {
  count = var.ssl_certificate_enabled ? 1 : 0

  name = "${var.name}-https-proxy"

  url_map          = google_compute_url_map.lb_url_map.self_link
  ssl_certificates = [var.ssl_certificate_id]
  quic_override    = "NONE"
  ssl_policy       = join("", google_compute_ssl_policy.lb_target_https_ssl_policy.*.self_link)
}

resource "google_compute_global_address" "ip" {
  name = var.name
}

resource "google_compute_url_map" "http_to_https_redirect" {
  count = local.redirect_http_to_https ? 1 : 0

  name = "http-redirect"

  default_url_redirect {
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
    strip_query            = false
    https_redirect         = true
  }
}

resource "google_compute_global_forwarding_rule" "lb_http_forwarding_rule" {
  name = "${var.name}-http-frontend"

  target     = google_compute_target_http_proxy.lb_target_http_proxy.self_link
  port_range = "80"
  ip_address = google_compute_global_address.ip.address
}

resource "google_compute_global_forwarding_rule" "lb_https_forwarding_rule" {
  count = var.ssl_certificate_enabled ? 1 : 0

  name = "${var.name}-https-frontend"

  target     = join("", google_compute_target_https_proxy.lb_target_https_proxy.*.self_link)
  port_range = "443"
  ip_address = google_compute_global_address.ip.address
}
