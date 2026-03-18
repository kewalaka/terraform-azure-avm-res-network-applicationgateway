#---------- All Required Pre-requisites Section-----------

# Below code allow you to create Azure resource group for application gateway, 
# Virtual network, subnets, log analytics workspace, virtual machine scale set, 
# network security group, storage account, key vault and user assigned identity.

# Resource Group for Application Gateway
resource "azapi_resource" "rg_group" {
  type     = "Microsoft.Resources/resourceGroups@2024-03-01"
  name     = module.naming.resource_group.name_unique
  location = "australiaeast"
}

# Resource Group for VNET
module "naming_rg_vnet" {
  source  = "Azure/naming/azurerm"
  version = "0.3.0"

  suffix = ["vnet"]
}

resource "azapi_resource" "rg_vnet" {
  type     = "Microsoft.Resources/resourceGroups@2024-03-01"
  name     = module.naming_rg_vnet.resource_group.name_unique
  location = "australiaeast"
}

resource "azapi_resource" "vnet" {
  type      = "Microsoft.Network/virtualNetworks@2024-05-01"
  name      = module.naming.virtual_network.name_unique
  location  = azapi_resource.rg_vnet.location
  parent_id = azapi_resource.rg_vnet.id

  body = {
    properties = {
      addressSpace = {
        addressPrefixes = ["100.64.0.0/16"]
      }
    }
  }
}

resource "azapi_resource" "subnet_frontend" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2024-05-01"
  name      = "frontend"
  parent_id = azapi_resource.vnet.id

  body = {
    properties = {
      addressPrefix = "100.64.0.0/24"
    }
  }
}

resource "azapi_resource" "subnet_backend" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2024-05-01"
  name      = "backend"
  parent_id = azapi_resource.vnet.id

  body = {
    properties = {
      addressPrefix = "100.64.1.0/24"
    }
  }

  depends_on = [azapi_resource.subnet_frontend]
}

# Required for to deploy VMSS and Web Server to host application
resource "azapi_resource" "subnet_workload" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2024-05-01"
  name      = "workload"
  parent_id = azapi_resource.vnet.id

  body = {
    properties = {
      addressPrefix = "100.64.2.0/24"
    }
  }

  depends_on = [azapi_resource.subnet_backend]
}

# Required for Frontend Private IP endpoint testing 
resource "azapi_resource" "subnet_private_ip_test" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2024-05-01"
  name      = "private_ip_test"
  parent_id = azapi_resource.vnet.id

  body = {
    properties = {
      addressPrefix = "100.64.3.0/24"
    }
  }

  depends_on = [azapi_resource.subnet_workload]
}

#-----------------------------------------------------------------
#  Enable these to deploy sample application to VMSS 
#  Enable these code to test private IP endpoint via bastion host  
#-----------------------------------------------------------------

# # Required bastion host subnet to test private IP endpoint
# resource "azapi_resource" "subnet_bastion" {
#   type      = "Microsoft.Network/virtualNetworks/subnets@2024-05-01"
#   name      = "AzureBastionSubnet"
#   parent_id = azapi_resource.vnet.id
#
#   body = {
#     properties = {
#       addressPrefix = "100.64.4.0/24"
#     }
#   }
#
#   depends_on = [azapi_resource.subnet_private_ip_test]
# }

resource "azapi_resource" "log_analytics_workspace" {
  type      = "Microsoft.OperationalInsights/workspaces@2023-09-01"
  name      = module.naming.log_analytics_workspace.name_unique
  location  = azapi_resource.rg_group.location
  parent_id = azapi_resource.rg_vnet.id

  body = {
    properties = {
      sku = {
        name = "PerGB2018"
      }
    }
  }
}

#-----------------------------------------------------------------
#  Enable these to deploy sample application to VMSS 
#  Enable these code to test private IP endpoint via bastion host  
#-----------------------------------------------------------------

# resource "azapi_resource" "bastion_win_vm_nic" {
#   type      = "Microsoft.Network/networkInterfaces@2024-05-01"
#   name      = module.naming.network_interface.name_unique
#   location  = azapi_resource.rg_group.location
#   parent_id = azapi_resource.rg_vnet.id
#
#   body = {
#     properties = {
#       ipConfigurations = [
#         {
#           name = module.naming.network_interface.name_unique
#           properties = {
#             subnet = {
#               id = azapi_resource.subnet_private_ip_test.id
#             }
#             privateIPAllocationMethod = "Dynamic"
#           }
#         }
#       ]
#     }
#   }
# }

# resource "azapi_resource" "bastion_public_ip" {
#   type      = "Microsoft.Network/publicIPAddresses@2024-05-01"
#   name      = module.naming.public_ip.name_unique
#   location  = azapi_resource.rg_group.location
#   parent_id = azapi_resource.rg_vnet.id
#
#   body = {
#     properties = {
#       publicIPAllocationMethod = "Static"
#     }
#     sku = {
#       name = "Standard"
#     }
#   }
# }

# resource "azapi_resource" "bastion_host" {
#   type      = "Microsoft.Network/bastionHosts@2024-05-01"
#   name      = module.naming.bastion_host.name_unique
#   location  = azapi_resource.rg_group.location
#   parent_id = azapi_resource.rg_vnet.id
#
#   body = {
#     properties = {
#       scaleUnits = 2
#       ipConfigurations = [
#         {
#           name = "bastion-Ip-configuration"
#           properties = {
#             subnet = {
#               id = azapi_resource.subnet_bastion.id
#             }
#             publicIPAddress = {
#               id = azapi_resource.bastion_public_ip.id
#             }
#           }
#         }
#       ]
#     }
#   }
# }

# resource "azapi_resource" "ag_subnet_nsg" {
#   type      = "Microsoft.Network/networkSecurityGroups@2024-05-01"
#   name      = module.naming.network_security_group.name_unique
#   location  = azapi_resource.rg_group.location
#   parent_id = azapi_resource.rg_vnet.id
#
#   body = {
#     properties = {
#       securityRules = [
#         {
#           name = "Rule-Port-80-Allow"
#           properties = {
#             priority                   = 100
#             direction                  = "Inbound"
#             access                     = "Allow"
#             protocol                   = "Tcp"
#             sourcePortRange            = "*"
#             destinationPortRange       = "80"
#             sourceAddressPrefix        = "*"
#             destinationAddressPrefix   = "*"
#           }
#         }
#       ]
#     }
#   }
# }
