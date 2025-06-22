variable "windows_vms" {
  type = map(object({
    size     = string
    os_image = string
    nics = map(object({
      name             = string
      join_subnet_key = string
      public_ip       = bool
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

variable "bastion-sku" {
  type = string
}

variable "bastion-address-prefix" {
  type = string
}