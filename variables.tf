variable "windows_vms" {
  type = map(object({
    size     = string
    os_image = string
    zone     = list(string)
    nics = map(object({
      name             = string
      join_subnet_key = string
      public_ip       = bool
      lb_flag        = bool
    }))
  }))
}

variable "vnets" {
  type = map(object({
    address_prefix =  string
  }))
}

variable "subnets" {
  type = map(object({
    join_vnet_key = string
    address_prefix =  string
  }))
}

#システム固有名詞（アプリケーション、システム、ワークロード名）
variable "system-name" {
  type = string
}

# variable "bastion" {
#   type = object({
#     name = string
#     address_prefix = string
#     bastion_sku = string
#   })
# }

variable "mz_nsgs" {
  type = map(object({
    attached_subnets_key = list(string)
    rules = map(object({
      priority = number
      direction = string
      access = string
      protocol = string
      source_port_range = string
      destination_port_range = string
      source_address_prefix = string
      destination_address_prefix = string
    }))
  }))
}

variable "lb" {
  type = object({
    frontend_ip_configuration_name = string
    public_ip_address_name = string
    backend_address_pool_name = string
    probe_name = string
    rule_name = string
  })
}

variable "storageaccount" {
  type = object({
    name = string
    account_tier = string
    account_replication_type = string
  })
}

variable "loganalyticsworkspace" {
  type = object({
    name = string
    retention_in_days = number
  })
}

variable "dce" {
  type = object({
    name = string
  })
}