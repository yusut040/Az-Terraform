vnets = {
  "vnet01" = {
    address_prefix = "10.1.0.0/16"
  },
  "vnet02" = {
    address_prefix = "192.168.0.0/16"
  }
}

lb ={
    frontend_ip_configuration_name = "PublicIPAddress"
    public_ip_address_name = "PublicIPForLB"
    backend_address_pool_name = "BackEndAddressPool"
    probe_name = "http-running-probe"
    rule_name = "http-running-rule"
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
  },
  "subnet04" = {
    join_vnet_key      = "vnet01"
    address_prefix = "10.1.3.0/24"
  },
}

mz_nsgs = {
  "allowrdp-01" = {
    attached_subnets_key = ["subnet02", "subnet03"]
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
  "allowhttp-https-01" = {
    attached_subnets_key = ["subnet01"]
    rules = {
      "allow-http" = {
        priority = 120
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "80"
        source_address_prefix = "*"
        destination_address_prefix = "*"
      }
      "allow-https" = {
        priority = 130
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "443"
        source_address_prefix = "*"
        destination_address_prefix = "*"
      }
    }
  }
}
