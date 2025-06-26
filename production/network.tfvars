vnets = {
  "01" = {
    address_prefix = "10.1.0.0/16"
  },
  "02" = {
    address_prefix = "192.168.0.0/16"
  }
}

subnets = {
  "01" = {
    join_vnet_key      = "01"
    address_prefix = "10.1.1.0/24"
  },
  "02" = {
    join_vnet_key      = "01"
    address_prefix = "10.1.2.0/24"
  },
  "03" = {
    join_vnet_key      = "02"
    address_prefix = "192.168.1.0/24"
  }
}

nsgs = {
  "01" = {
    name = "nsg-01"
    rules = {
      "allow-ssh" = {
        priority = 100
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "22"
        source_address_prefix = "*"
        destination_address_prefix = "*"
      },
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
      "allow-ssh" = {
        priority = 100
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "22"
        source_address_prefix = "*"
        destination_address_prefix = "*"
      },
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
