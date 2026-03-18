
#----------Testing Use Case  -------------
# Application Gateway routing traffic from your application.
# Assume that your Application runing the scale set contains two virtual machine instances.
# The scale set is added to the default backend pool need to updated with IP or FQDN of the application gateway.
# The example input from https://learn.microsoft.com/en-us/azure/application-gateway/tutorial-manage-web-traffic-cli

#----------All Required Provider Section-----------
terraform {
  required_version = ">= 1.9, < 2.0"

  required_providers {
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5.0, < 4.0.0"
    }
  }
}

provider "azapi" {}

# This ensures we have unique CAF compliant names for our resources.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.3.0"

  suffix = ["agw"]
}

# This allows us to randomize the region for the resource group.
module "regions" {
  source  = "Azure/avm-utl-regions/azurerm"
  version = "0.11.0"
}

# This allows us to randomize the region for the resource group.
resource "random_integer" "region_index" {
  max = length(module.regions.regions) - 1
  min = 0
}

# Public IP for the Application Gateway
resource "azapi_resource" "public_ip" {
  type      = "Microsoft.Network/publicIPAddresses@2024-05-01"
  name      = "${module.naming.public_ip.name_unique}-pip"
  location  = azapi_resource.rg_group.location
  parent_id = azapi_resource.rg_group.id

  body = {
    properties = {
      publicIPAllocationMethod = "Static"
    }
    sku = {
      name = "Standard"
    }
    zones = ["1", "2", "3"]
  }
}

# Locals for constructing resource IDs for internal references
locals {
  app_gateway_id = "${azapi_resource.rg_group.id}/providers/Microsoft.Network/applicationGateways/${module.naming.application_gateway.name_unique}"

  frontend_ip_config_id    = "${local.app_gateway_id}/frontendIPConfigurations/appGatewayFrontendIpConfig"
  frontend_port_id         = "${local.app_gateway_id}/frontendPorts/frontend-port-80"
  backend_address_pool_id  = "${local.app_gateway_id}/backendAddressPools/appGatewayBackendPool"
  backend_http_settings_id = "${local.app_gateway_id}/backendHttpSettingsCollection/appGatewayBackendHttpSettings"
  http_listener_id         = "${local.app_gateway_id}/httpListeners/appGatewayHttpListener"
}

module "application_gateway" {
  source = "../../"

  # Parent resource ID (resource group)
  parent_id = azapi_resource.rg_group.id
  location  = azapi_resource.rg_group.location
  name      = module.naming.application_gateway.name_unique

  # SKU configuration
  sku = {
    name = "Standard_v2"
    tier = "Standard_v2"
  }

  # Autoscale configuration
  autoscale_configuration = {
    min_capacity = 2
    max_capacity = 3
  }

  # Gateway IP configuration
  gateway_ip_configurations = [
    {
      name = "appGatewayIpConfig"
      properties = {
        subnet = {
          id = azapi_resource.subnet_backend.id
        }
      }
    }
  ]

  # Frontend IP configuration
  frontend_ip_configurations = [
    {
      name = "appGatewayFrontendIpConfig"
      properties = {
        public_ip_address = {
          id = azapi_resource.public_ip.id
        }
      }
    }
  ]

  # Frontend port configuration
  # WAF : This example NO HTTPS, We recommend to Secure all incoming connections using HTTPS for production services with end-to-end SSL/TLS or SSL/TLS termination at the Application Gateway to protect against attacks and ensure data remains private and encrypted between the web server and browsers.
  # WAF : Please refer kv_selfssl_waf_https_app_gateway example for HTTPS configuration
  frontend_ports = [
    {
      name = "frontend-port-80"
      properties = {
        port = 8080
      }
    }
  ]

  # Backend address pool configuration
  backend_address_pools = [
    {
      name = "appGatewayBackendPool"
      properties = {
        backend_addresses = [
          { ip_address = "100.64.2.6" },
          { ip_address = "100.64.2.5" }
        ]
        #fqdns example:
        # backend_addresses = [
        #   { fqdn = "example1.com" },
        #   { fqdn = "example2.com" }
        # ]
      }
    }
  ]

  # Backend http settings configuration
  backend_http_settings_collection = [
    {
      name = "appGatewayBackendHttpSettings"
      properties = {
        port                = 80
        protocol            = "Http"
        cookie_based_affinity = "Disabled"
        path                = "/"
        request_timeout     = 30
        connection_draining = {
          enabled              = true
          drain_timeout_in_sec = 300
        }
      }
    }
  ]

  # HTTP listeners configuration
  http_listeners = [
    {
      name = "appGatewayHttpListener"
      properties = {
        frontend_ip_configuration = {
          id = local.frontend_ip_config_id
        }
        frontend_port = {
          id = local.frontend_port_id
        }
        protocol = "Http"
      }
    }
  ]

  # Request routing rules configuration
  request_routing_rules = [
    {
      name = "rule-1"
      properties = {
        rule_type = "Basic"
        priority  = 100
        http_listener = {
          id = local.http_listener_id
        }
        backend_address_pool = {
          id = local.backend_address_pool_id
        }
        backend_http_settings = {
          id = local.backend_http_settings_id
        }
      }
    }
  ]

  # Zone redundancy for the application gateway
  zones = ["1", "2", "3"]

  tags = {
    environment = "dev"
    owner       = "application_gateway"
    project     = "AVM"
  }
}
