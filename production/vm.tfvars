#このファイルはTerraformの変数定義ファイルです。
#各リソースの設定値をここに記載します。
#ネーミングルールに関してはMicrosoft社公式の命名規則に則っています。
#https://learn.microsoft.com/ja-jp/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming

#アプリケーション名、サブスクリプションの目的
system-name = "ytoyoda8"

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

#VMのリソース名はvm-<mapのキー>-prodとする
windows_vms = {
  "ap01" = {
    size     = "Standard_B2as_v2"
    os_image = "2022-Datacenter"
    nics = {
      "nic01" = {
        name = "ap01-nic"
        join_subnet_key = "02"
        public_ip       = false
      },
      "nic01-2" = {
        name = "ap01-nic-2"
        join_subnet_key = "02"
        public_ip       = false
      }
    }
  },
  "db01" = {
    size     = "Standard_B2as_v2"
    os_image = "2022-Datacenter"
    nics = {
      "nic02" = {
        name = "db01-nic"
        join_subnet_key = "02"
        public_ip       = false
      }
    }
  },
  "web01" = {
    size     = "Standard_B2as_v2"
    os_image = "2022-Datacenter"
    nics = {
      "nic03" = {
        name = "web01-nic"
        join_subnet_key = "01"
        public_ip       = false
      }
    }
  }
}

#Bastionの設定
#Bastionについては複数作成する想定はないためmapでの定義はしていません。
bastion-address-prefix = "10.1.3.0/26"
bastion-sku = "Basic"