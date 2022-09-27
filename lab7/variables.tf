# variables.tf

variable "region" {
    description = "The region location for your Azure resources"
    type = string
    default = "Norway East"
}

variable "prefix" {
    description = "The prefix for your azure resources to provide unique resource names"
    type = string
}

variable "tags" {
    description = "Tags for your resource group. Enter as key/value pair"
    type = map(string)
}

variable "vmpassword" {
    description = "Enter password for your VM"
    type = string
    sensitive = true
}