[![Release][release-image]][release] [![CI][ci-image]][ci] [![License][license-image]][license] [![Registry][registry-image]][registry]

# terraform-google-lb

A Terraform module for deploying the parts required to load balance traffic into a GCP instance group.  Both HTTP(80) and HTTPS(443) proxies are deployed - the later optionally only if the required SSL certificate is provided.  For TLS traffic we are defaulting to TLS 1.2.

## Usage

At a minimum the load balancer needs 4 bits of information - a unique name, the named port to forward traffic on, the URL of the instance group to bind traffic onto and a self-link to the health check resource which is attached to the instance group.

```hcl
module "collector_lb" {
  source = "snowplow-devops/lb/google"

  name = "collector-lb"

  instance_group_named_port_http = "http"
  instance_group_url             = var.instance_group_url
  health_check_self_link         = var.health_check_self_link
}
```

### Adding a custom certificate

To add a certificate to the load balancer and therefore enable the TLS endpoint you will need to populate two extra variables:

```hcl
module "collector_lb" {
  source = "snowplow-devops/lb/google"

  name = "collector-lb"

  instance_group_named_port_http = "http"
  instance_group_url             = var.instance_group_url
  health_check_self_link         = var.health_check_self_link

  ssl_certificate_id      = "your-certificate-id-here"
  ssl_certificate_enabled = true
}
```

_Note_: `ssl_certificate_enabled` is required to allow for the case where you are creating the certificate in-line with the LB module as Terraform will not be able to figure out the "count" attribute correctly at plan time.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 3.44.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 3.44.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_backend_service.lb_backend](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_backend_service) | resource |
| [google_compute_global_address.ip](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_address) | resource |
| [google_compute_global_forwarding_rule.lb_http_forwarding_rule](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_forwarding_rule) | resource |
| [google_compute_global_forwarding_rule.lb_https_forwarding_rule](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_forwarding_rule) | resource |
| [google_compute_ssl_policy.lb_target_https_ssl_policy](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_ssl_policy) | resource |
| [google_compute_target_http_proxy.lb_target_http_proxy](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_target_http_proxy) | resource |
| [google_compute_target_https_proxy.lb_target_https_proxy](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_target_https_proxy) | resource |
| [google_compute_url_map.lb_url_map](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_url_map) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_health_check_self_link"></a> [health\_check\_self\_link](#input\_health\_check\_self\_link) | The URL of the instance group health check | `string` | n/a | yes |
| <a name="input_instance_group_named_port_http"></a> [instance\_group\_named\_port\_http](#input\_instance\_group\_named\_port\_http) | The name of the HTTP port exposed by the instance group | `string` | n/a | yes |
| <a name="input_instance_group_url"></a> [instance\_group\_url](#input\_instance\_group\_url) | The URL of the instance group to bind to the backend service | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | A name which will be pre-pended to the resources created | `string` | n/a | yes |
| <a name="input_ssl_certificate_enabled"></a> [ssl\_certificate\_enabled](#input\_ssl\_certificate\_enabled) | A boolean which triggers adding or removing the HTTPS proxy | `bool` | `false` | no |
| <a name="input_ssl_certificate_id"></a> [ssl\_certificate\_id](#input\_ssl\_certificate\_id) | The ID of a Google Managed certificate to attach to the load balancer | `string` | `""` | no |
| <a name="input_ssl_min_tls_version"></a> [ssl\_min\_tls\_version](#input\_ssl\_min\_tls\_version) | The minimum TLS version to use (https://cloud.google.com/load-balancing/docs/ssl-policies-concepts#defining_an_ssl_policy) | `string` | `"TLS_1_2"` | no |
| <a name="input_ssl_profile"></a> [ssl\_profile](#input\_ssl\_profile) | The SSL Profile to use (https://cloud.google.com/load-balancing/docs/ssl-policies-concepts#defining_an_ssl_policy) | `string` | `"MODERN"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ip_address"></a> [ip\_address](#output\_ip\_address) | n/a |

# Copyright and license

The Terraform Google Load Balancer project is Copyright 2021-present Snowplow Analytics Ltd.

Licensed under the [Snowplow Community License](https://docs.snowplow.io/community-license-1.0). _(If you are uncertain how it applies to your use case, check our answers to [frequently asked questions](https://docs.snowplow.io/docs/contributing/community-license-faq/).)_

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

[release]: https://github.com/snowplow-devops/terraform-google-lb/releases/latest
[release-image]: https://img.shields.io/github/v/release/snowplow-devops/terraform-google-lb

[ci]: https://github.com/snowplow-devops/terraform-google-lb/actions?query=workflow%3Aci
[ci-image]: https://github.com/snowplow-devops/terraform-google-lb/workflows/ci/badge.svg

[license]: https://docs.snowplow.io/docs/contributing/community-license-faq/
[license-image]: https://img.shields.io/badge/license-Snowplow--Community-blue.svg?style=flat

[registry]: https://registry.terraform.io/modules/snowplow-devops/lb/google/latest
[registry-image]: https://img.shields.io/static/v1?label=Terraform&message=Registry&color=7B42BC&logo=terraform
