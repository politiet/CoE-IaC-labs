resource "azurerm_resource_group" "rgs" {  
    count = length(var.rg_names)
    name = "${var.rg_names[count.index]}-${var.prefix}"
    location = var.region
}

resource "azurerm_virtual_network" "vnets" {
    count               = length(var.rg_names)
    name                = lookup(var.vnets[count.index], "name")
    address_space       = [lookup(var.vnets[count.index], "address")]
    location            = var.region
    resource_group_name = azurerm_resource_group.rgs[count.index].name
}