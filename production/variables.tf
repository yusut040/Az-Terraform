variable "windows_vms" {
  type = map(object({
    size     = string
    os_image = string
  }))
}

variable "vnets" {
  type = map(object({
    address_prefix =  string
  }))
}

variable "subnets" {
  type = map(object({
    address_prefix =  string
  }))
}

variable "vm_nics" {
  type = map(object({
    name = string
    subnet_key = string
  }))
}

#システム固有名詞（アプリケーション、システム、ワークロード名）
variable "system-name" {
  type = string
}