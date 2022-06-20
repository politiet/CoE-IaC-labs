# variables.tf

variable "region" {
    description = "The region location for your Azure resources"
    type = string
    default = "Norway East"
}

variable "prefix" {
    description = "The prefix for your azure resources to provide unique name"
    type = string
}
