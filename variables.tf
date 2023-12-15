variable "name" {
  description = "A name which will be pre-pended to the resources created"
  type        = string
}

variable "instance_group_named_port_http" {
  description = "The name of the HTTP port exposed by the instance group"
  type        = string
}

variable "instance_group_url" {
  description = "The URL of the instance group to bind to the backend service"
  type        = string
}

variable "health_check_self_link" {
  description = "The URL of the instance group health check"
  type        = string
}

variable "ssl_certificate_enabled" {
  description = "A boolean which triggers adding or removing the HTTPS proxy"
  type        = bool
  default     = false
}

variable "ssl_certificate_id" {
  description = "The ID of a Google Managed certificate to attach to the load balancer"
  type        = string
  default     = ""
}

variable "ssl_profile" {
  description = "The SSL Profile to use (https://cloud.google.com/load-balancing/docs/ssl-policies-concepts#defining_an_ssl_policy)"
  default     = "MODERN"
  type        = string
}

variable "ssl_min_tls_version" {
  description = "The minimum TLS version to use (https://cloud.google.com/load-balancing/docs/ssl-policies-concepts#defining_an_ssl_policy)"
  default     = "TLS_1_2"
  type        = string
}

variable "redirect_http_to_https" {
  description = "A boolean which makes the HTTP proxy redirect to HTTPS"
  type        = bool
  default     = false
}
