provider "azurerm" {
  features {}
  subscription_id = "8d1fdb80-e459-4800-9aef-8d755086c04b"
  tenant_id       = "e9e03440-395a-4a40-90f9-a6fbab86cc78"
}

resource "azurerm_resource_group" "main" {
  name     = "fullstack3tiers-rg"
  location = "eastus"
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "fullstack3tiers-aks"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = "fullstack3tiers"

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_B2s"
  }

  identity {
    type = "SystemAssigned"
  }
}


output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}
