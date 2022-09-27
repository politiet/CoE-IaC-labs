## Lab 9 - Create a local module

1. Create a new seperate local folder for this project with the structure:

|-- myproject
|   |-- main.tf
|   |-- modules
|   |   |__ connectedrg
|   |       |-- main.tf
|   |       |-- output.tf
|   |       |-- variables.tf
|   |-- output.tf
|   |-- terraform.tfvars
|   |-- variables.tf

2. The module should be able to create a resource group for a given list of rg_names and create a vnet for each of the resource groups as well

3. Add your prefix to the module RG names

Hint: Use **list** for a squence of values, **map** for group of key/value pairs, **lookup** retrives value of a single element from a map, **count** for creating many instances of the same resource. 

Input example: 

rg_names = [
    "rg-connected-dev",
    "rg-connected-test",
    "rg-connected-prod",
    "rg-connected-staging"
]

vnets = [
    {
        name = "dev_vnet"
        address = "10.0.0.0/16"
    },
    {
        name = "test_vnet"
        address = "10.1.0.0/16"
    },
    {
        name = "prod_vnet"
        address = "10.2.0.0/16"
    },
    {
        name = "staging_vnet"
        address = "10.3.0.0/16"
    },
]