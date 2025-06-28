vnets = {
  "vnet01" = {
    address_prefix = "10.1.0.0/16"
  },
  "vnet02" = {
    address_prefix = "192.168.0.0/16"
  }
}

subnets = {
  "subnet01" = {
    join_vnet_key      = "vnet01"
    address_prefix = "10.1.1.0/24"
  },
  "subnet02" = {
    join_vnet_key      = "vnet01"
    address_prefix = "10.1.2.0/24"
  },
  "subnet03" = {
    join_vnet_key      = "vnet02"
    address_prefix = "192.168.1.0/24"
  }
}

mz_nsgs = {
  "01" = {
    name = "nsg-01"
    rules = {
      "allow-rdp" = {
        priority = 110
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "3389"
        source_address_prefix = "*"
        destination_address_prefix = "*"
      }
    }
  },
  "02" = {
    name = "nsg-02"
    rules = {
      "allow-rdp" = {
        priority = 110
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "3389"
        source_address_prefix = "*"
        destination_address_prefix = "*"
      }
    }
  }
}
