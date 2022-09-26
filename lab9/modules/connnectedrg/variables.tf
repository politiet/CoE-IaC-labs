variable rg_names {
    type = list(string)    
}

variable vnets {
    type = list(map(string))    
}

variable prefix {
    type = string
    default = "stale"
}

variable region {           
    type = string
    default = "Norway East"
}