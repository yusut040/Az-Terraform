variable "windows_vms" {
  type = map(object({
    size     = string
    os_image = string
  }))
}

variable "vnets" {
  type = map(object({
    address_prefixes =  string
  }))
}

variable "subnets" {
  type = map(object({
    address_prefixes =  string
  }))
}

variable "vm_nics" {
  type = map(object({
    name = string
  }))
}

#システム固有名詞（アプリケーション、システム、ワークロード名）
variable "system-name" {
  type = string
  description = "value"
}

variable "resource_group_name" {
  type = string
}