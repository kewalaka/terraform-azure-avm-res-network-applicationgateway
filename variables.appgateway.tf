variable "parent_id" {
  description = <<DESCRIPTION
The parent resource ID for this resource.
DESCRIPTION
  type        = string
}

variable "id" {
  description = <<DESCRIPTION
Resource ID.
DESCRIPTION
  type        = string
  default     = null
}

variable "authentication_certificates" {
  description = <<DESCRIPTION
Authentication certificates of the application gateway resource. For default limits, see [Application Gateway limits](https://docs.microsoft.com/azure/azure-subscription-service-limits#application-gateway-limits).
DESCRIPTION
  type = list(object({
    name = optional(string)
    properties = optional(object({
      data = optional(string)
    }))
  }))
  default = null
}

variable "autoscale_configuration" {
  description = <<DESCRIPTION
Application Gateway autoscale configuration.
DESCRIPTION
  type = object({
    max_capacity = optional(number)
    min_capacity = number
  })
  default = null
}

variable "backend_address_pools" {
  description = <<DESCRIPTION
Backend address pool of the application gateway resource. For default limits, see [Application Gateway limits](https://docs.microsoft.com/azure/azure-subscription-service-limits#application-gateway-limits).
DESCRIPTION
  type = list(object({
    name = optional(string)
    properties = optional(object({
      backend_addresses = optional(list(object({
        fqdn       = optional(string)
        ip_address = optional(string)
      })))
    }))
  }))
  default = null
}

variable "backend_http_settings_collection" {
  description = <<DESCRIPTION
Backend http settings of the application gateway resource. For default limits, see [Application Gateway limits](https://docs.microsoft.com/azure/azure-subscription-service-limits#application-gateway-limits).
DESCRIPTION
  type = list(object({
    name = optional(string)
    properties = optional(object({
      affinity_cookie_name = optional(string)
      authentication_certificates = optional(list(object({
        id = optional(string)
      })))
      connection_draining = optional(object({
        drain_timeout_in_sec = number
        enabled              = bool
      }))
      cookie_based_affinity               = optional(string)
      dedicated_backend_connection        = optional(bool)
      host_name                           = optional(string)
      path                                = optional(string)
      pick_host_name_from_backend_address = optional(bool)
      port                                = optional(number)
      probe = optional(object({
        id = optional(string)
      }))
      probe_enabled   = optional(bool)
      protocol        = optional(string)
      request_timeout = optional(number)
      sni_name        = optional(string)
      trusted_root_certificates = optional(list(object({
        id = optional(string)
      })))
      validate_cert_chain_and_expiry = optional(bool)
      validate_sni                   = optional(bool)
    }))
  }))
  default = null
}

variable "backend_settings_collection" {
  description = <<DESCRIPTION
Backend settings of the application gateway resource. For default limits, see [Application Gateway limits](https://docs.microsoft.com/azure/azure-subscription-service-limits#application-gateway-limits).
DESCRIPTION
  type = list(object({
    name = optional(string)
    properties = optional(object({
      enable_l4_client_ip_preservation    = optional(bool)
      host_name                           = optional(string)
      pick_host_name_from_backend_address = optional(bool)
      port                                = optional(number)
      probe = optional(object({
        id = optional(string)
      }))
      protocol = optional(string)
      timeout  = optional(number)
      trusted_root_certificates = optional(list(object({
        id = optional(string)
      })))
    }))
  }))
  default = null
}

variable "custom_error_configurations" {
  description = <<DESCRIPTION
Custom error configurations of the application gateway resource.
DESCRIPTION
  type = list(object({
    custom_error_page_url = optional(string)
    status_code           = optional(string)
  }))
  default = null
}

variable "enable_fips" {
  description = <<DESCRIPTION
Whether FIPS is enabled on the application gateway resource.
DESCRIPTION
  type        = bool
  default     = null
}

variable "enable_http2" {
  description = <<DESCRIPTION
Whether HTTP2 is enabled on the application gateway resource.
DESCRIPTION
  type        = bool
  default     = null
}

variable "entra_jwt_validation_configs" {
  description = <<DESCRIPTION
Entra JWT validation configurations for the application gateway resource. For default limits, see [Application Gateway limits](https://docs.microsoft.com/azure/azure-subscription-service-limits#application-gateway-limits).
DESCRIPTION
  type = list(object({
    name = optional(string)
    properties = optional(object({
      audiences                    = optional(list(string))
      client_id                    = optional(string)
      tenant_id                    = optional(string)
      un_authorized_request_action = optional(string)
    }))
  }))
  default = null
}

variable "firewall_policy" {
  description = <<DESCRIPTION
Reference to another subresource.
DESCRIPTION
  type = object({
    id = optional(string)
  })
  default = null
}

variable "force_firewall_policy_association" {
  description = <<DESCRIPTION
If true, associates a firewall policy with an application gateway regardless whether the policy differs from the WAF Config.
DESCRIPTION
  type        = bool
  default     = null
}

variable "frontend_ip_configurations" {
  description = <<DESCRIPTION
Frontend IP addresses of the application gateway resource. For default limits, see [Application Gateway limits](https://docs.microsoft.com/azure/azure-subscription-service-limits#application-gateway-limits).
DESCRIPTION
  type = list(object({
    name = optional(string)
    properties = optional(object({
      private_ip_address           = optional(string)
      private_ip_allocation_method = optional(string)
      private_link_configuration = optional(object({
        id = optional(string)
      }))
      public_ip_address = optional(object({
        id = optional(string)
      }))
      subnet = optional(object({
        id = optional(string)
      }))
    }))
  }))
  default = null
}

variable "frontend_ports" {
  description = <<DESCRIPTION
Frontend ports of the application gateway resource. For default limits, see [Application Gateway limits](https://docs.microsoft.com/azure/azure-subscription-service-limits#application-gateway-limits).
DESCRIPTION
  type = list(object({
    name = optional(string)
    properties = optional(object({
      port = optional(number)
    }))
  }))
  default = null
}

variable "gateway_ip_configurations" {
  description = <<DESCRIPTION
Subnets of the application gateway resource. For default limits, see [Application Gateway limits](https://docs.microsoft.com/azure/azure-subscription-service-limits#application-gateway-limits).
DESCRIPTION
  type = list(object({
    name = optional(string)
    properties = optional(object({
      subnet = optional(object({
        id = optional(string)
      }))
    }))
  }))
  default = null
}

variable "global_configuration" {
  description = <<DESCRIPTION
Application Gateway global configuration.
DESCRIPTION
  type = object({
    enable_request_buffering  = optional(bool)
    enable_response_buffering = optional(bool)
  })
  default = null
}

variable "http_listeners" {
  description = <<DESCRIPTION
Http listeners of the application gateway resource. For default limits, see [Application Gateway limits](https://docs.microsoft.com/azure/azure-subscription-service-limits#application-gateway-limits).
DESCRIPTION
  type = list(object({
    name = optional(string)
    properties = optional(object({
      custom_error_configurations = optional(list(object({
        custom_error_page_url = optional(string)
        status_code           = optional(string)
      })))
      firewall_policy = optional(object({
        id = optional(string)
      }))
      frontend_ip_configuration = optional(object({
        id = optional(string)
      }))
      frontend_port = optional(object({
        id = optional(string)
      }))
      host_name                      = optional(string)
      host_names                     = optional(list(string))
      protocol                       = optional(string)
      require_server_name_indication = optional(bool)
      ssl_certificate = optional(object({
        id = optional(string)
      }))
      ssl_profile = optional(object({
        id = optional(string)
      }))
    }))
  }))
  default = null
}

variable "listeners" {
  description = <<DESCRIPTION
Listeners of the application gateway resource. For default limits, see [Application Gateway limits](https://docs.microsoft.com/azure/azure-subscription-service-limits#application-gateway-limits).
DESCRIPTION
  type = list(object({
    name = optional(string)
    properties = optional(object({
      frontend_ip_configuration = optional(object({
        id = optional(string)
      }))
      frontend_port = optional(object({
        id = optional(string)
      }))
      host_names = optional(list(string))
      protocol   = optional(string)
      ssl_certificate = optional(object({
        id = optional(string)
      }))
      ssl_profile = optional(object({
        id = optional(string)
      }))
    }))
  }))
  default = null
}

variable "load_distribution_policies" {
  description = <<DESCRIPTION
Load distribution policies of the application gateway resource.
DESCRIPTION
  type = list(object({
    name = optional(string)
    properties = optional(object({
      load_distribution_algorithm = optional(string)
      load_distribution_targets = optional(list(object({
        id   = optional(string)
        name = optional(string)
        properties = optional(object({
          backend_address_pool = optional(object({
            id = optional(string)
          }))
          weight_per_server = optional(number)
        }))
      })))
    }))
  }))
  default = null
}

variable "private_link_configurations" {
  description = <<DESCRIPTION
PrivateLink configurations on application gateway.
DESCRIPTION
  type = list(object({
    name = optional(string)
    properties = optional(object({
      ip_configurations = optional(list(object({
        id   = optional(string)
        name = optional(string)
        properties = optional(object({
          primary                      = optional(bool)
          private_ip_address           = optional(string)
          private_ip_allocation_method = optional(string)
          subnet = optional(object({
            id = optional(string)
          }))
        }))
      })))
    }))
  }))
  default = null
}

variable "probes" {
  description = <<DESCRIPTION
Probes of the application gateway resource.
DESCRIPTION
  type = list(object({
    id   = optional(string)
    name = optional(string)
    properties = optional(object({
      enable_probe_proxy_protocol_header = optional(bool)
      host                               = optional(string)
      interval                           = optional(number)
      match = optional(object({
        body         = optional(string)
        status_codes = optional(list(string))
      }))
      min_servers                               = optional(number)
      path                                      = optional(string)
      pick_host_name_from_backend_http_settings = optional(bool)
      pick_host_name_from_backend_settings      = optional(bool)
      port                                      = optional(number)
      protocol                                  = optional(string)
      timeout                                   = optional(number)
      unhealthy_threshold                       = optional(number)
    }))
  }))
  default = null
}

variable "redirect_configurations" {
  description = <<DESCRIPTION
Redirect configurations of the application gateway resource. For default limits, see [Application Gateway limits](https://docs.microsoft.com/azure/azure-subscription-service-limits#application-gateway-limits).
DESCRIPTION
  type = list(object({
    name = optional(string)
    properties = optional(object({
      include_path         = optional(bool)
      include_query_string = optional(bool)
      path_rules = optional(list(object({
        id = optional(string)
      })))
      redirect_type = optional(string)
      request_routing_rules = optional(list(object({
        id = optional(string)
      })))
      target_listener = optional(object({
        id = optional(string)
      }))
      target_url = optional(string)
      url_path_maps = optional(list(object({
        id = optional(string)
      })))
    }))
  }))
  default = null
}

variable "request_routing_rules" {
  description = <<DESCRIPTION
Request routing rules of the application gateway resource.
DESCRIPTION
  type = list(object({
    name = optional(string)
    properties = optional(object({
      backend_address_pool = optional(object({
        id = optional(string)
      }))
      backend_http_settings = optional(object({
        id = optional(string)
      }))
      entra_jwt_validation_config = optional(object({
        id = optional(string)
      }))
      http_listener = optional(object({
        id = optional(string)
      }))
      load_distribution_policy = optional(object({
        id = optional(string)
      }))
      priority = optional(number)
      redirect_configuration = optional(object({
        id = optional(string)
      }))
      rewrite_rule_set = optional(object({
        id = optional(string)
      }))
      rule_type = optional(string)
      url_path_map = optional(object({
        id = optional(string)
      }))
    }))
  }))
  default = null
}

variable "rewrite_rule_sets" {
  description = <<DESCRIPTION
Rewrite rules for the application gateway resource.
DESCRIPTION
  type = list(object({
    id   = optional(string)
    name = optional(string)
    properties = optional(object({
      rewrite_rules = optional(list(object({
        action_set = optional(object({
          request_header_configurations = optional(list(object({
            header_name  = optional(string)
            header_value = optional(string)
            header_value_matcher = optional(object({
              ignore_case = optional(bool)
              negate      = optional(bool)
              pattern     = optional(string)
            }))
          })))
          response_header_configurations = optional(list(object({
            header_name  = optional(string)
            header_value = optional(string)
            header_value_matcher = optional(object({
              ignore_case = optional(bool)
              negate      = optional(bool)
              pattern     = optional(string)
            }))
          })))
          url_configuration = optional(object({
            modified_path         = optional(string)
            modified_query_string = optional(string)
            reroute               = optional(bool)
          }))
        }))
        conditions = optional(list(object({
          ignore_case = optional(bool)
          negate      = optional(bool)
          pattern     = optional(string)
          variable    = optional(string)
        })))
        name          = optional(string)
        rule_sequence = optional(number)
      })))
    }))
  }))
  default = null
}

variable "routing_rules" {
  description = <<DESCRIPTION
Routing rules of the application gateway resource.
DESCRIPTION
  type = list(object({
    name = optional(string)
    properties = optional(object({
      backend_address_pool = optional(object({
        id = optional(string)
      }))
      backend_settings = optional(object({
        id = optional(string)
      }))
      listener = optional(object({
        id = optional(string)
      }))
      priority  = number
      rule_type = optional(string)
    }))
  }))
  default = null
}

variable "sku" {
  description = <<DESCRIPTION
SKU of an application gateway.
DESCRIPTION
  type = object({
    capacity = optional(number)
    family   = optional(string)
    name     = optional(string)
    tier     = optional(string)
  })
  default = null
}

variable "ssl_certificates" {
  description = <<DESCRIPTION
SSL certificates of the application gateway resource. For default limits, see [Application Gateway limits](https://docs.microsoft.com/azure/azure-subscription-service-limits#application-gateway-limits).
DESCRIPTION
  type = list(object({
    name = optional(string)
    properties = optional(object({
      data                = optional(string)
      key_vault_secret_id = optional(string)
      password            = optional(string)
    }))
  }))
  default = null
}

variable "ssl_policy" {
  description = <<DESCRIPTION
Application Gateway Ssl policy.
DESCRIPTION
  type = object({
    cipher_suites          = optional(list(string))
    disabled_ssl_protocols = optional(list(string))
    min_protocol_version   = optional(string)
    policy_name            = optional(string)
    policy_type            = optional(string)
  })
  default = null
}

variable "ssl_profiles" {
  description = <<DESCRIPTION
SSL profiles of the application gateway resource. For default limits, see [Application Gateway limits](https://docs.microsoft.com/azure/azure-subscription-service-limits#application-gateway-limits).
DESCRIPTION
  type = list(object({
    name = optional(string)
    properties = optional(object({
      client_auth_configuration = optional(object({
        verify_client_auth_mode      = optional(string)
        verify_client_cert_issuer_dn = optional(bool)
        verify_client_revocation     = optional(string)
      }))
      ssl_policy = optional(object({
        cipher_suites          = optional(list(string))
        disabled_ssl_protocols = optional(list(string))
        min_protocol_version   = optional(string)
        policy_name            = optional(string)
        policy_type            = optional(string)
      }))
      trusted_client_certificates = optional(list(object({
        id = optional(string)
      })))
    }))
  }))
  default = null
}

variable "trusted_client_certificates" {
  description = <<DESCRIPTION
Trusted client certificates of the application gateway resource. For default limits, see [Application Gateway limits](https://docs.microsoft.com/azure/azure-subscription-service-limits#application-gateway-limits).
DESCRIPTION
  type = list(object({
    name = optional(string)
    properties = optional(object({
      data = optional(string)
    }))
  }))
  default = null
}

variable "trusted_root_certificates" {
  description = <<DESCRIPTION
Trusted Root certificates of the application gateway resource. For default limits, see [Application Gateway limits](https://docs.microsoft.com/azure/azure-subscription-service-limits#application-gateway-limits).
DESCRIPTION
  type = list(object({
    name = optional(string)
    properties = optional(object({
      data                = optional(string)
      key_vault_secret_id = optional(string)
    }))
  }))
  default = null
}

variable "url_path_maps" {
  description = <<DESCRIPTION
URL path map of the application gateway resource. For default limits, see [Application Gateway limits](https://docs.microsoft.com/azure/azure-subscription-service-limits#application-gateway-limits).
DESCRIPTION
  type = list(object({
    name = optional(string)
    properties = optional(object({
      default_backend_address_pool = optional(object({
        id = optional(string)
      }))
      default_backend_http_settings = optional(object({
        id = optional(string)
      }))
      default_load_distribution_policy = optional(object({
        id = optional(string)
      }))
      default_redirect_configuration = optional(object({
        id = optional(string)
      }))
      default_rewrite_rule_set = optional(object({
        id = optional(string)
      }))
      path_rules = optional(list(object({
        id   = optional(string)
        name = optional(string)
        properties = optional(object({
          backend_address_pool = optional(object({
            id = optional(string)
          }))
          backend_http_settings = optional(object({
            id = optional(string)
          }))
          firewall_policy = optional(object({
            id = optional(string)
          }))
          load_distribution_policy = optional(object({
            id = optional(string)
          }))
          paths = optional(list(string))
          redirect_configuration = optional(object({
            id = optional(string)
          }))
          rewrite_rule_set = optional(object({
            id = optional(string)
          }))
        }))
      })))
    }))
  }))
  default = null
}

variable "web_application_firewall_configuration" {
  description = <<DESCRIPTION
Application gateway web application firewall configuration.
DESCRIPTION
  type = object({
    disabled_rule_groups = optional(list(object({
      rule_group_name = string
      rules           = optional(list(number))
    })))
    enabled = bool
    exclusions = optional(list(object({
      match_variable          = string
      selector                = string
      selector_match_operator = string
    })))
    file_upload_limit_in_mb     = optional(number)
    firewall_mode               = string
    max_request_body_size       = optional(number)
    max_request_body_size_in_kb = optional(number)
    request_body_check          = optional(bool)
    rule_set_type               = string
    rule_set_version            = string
  })
  default = null
}

variable "zones" {
  description = <<DESCRIPTION
A list of availability zones denoting where the resource needs to come from.
DESCRIPTION
  type        = list(string)
  default     = null
}
