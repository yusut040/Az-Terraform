#このファイルはTerraformの変数定義ファイルです。
#各リソースの設定値をここに記載します。
#ネーミングルールに関してはMicrosoft社公式の命名規則に則っています。
#https://learn.microsoft.com/ja-jp/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming

#アプリケーション名、サブスクリプションの目的
system-name = "ytoyoda8"

#VMのリソース名はvm-<mapのキー>-prodとする
windows_vms = {
  "ap01" = {
    size     = "Standard_B2as_v2"
    os_image = "2022-Datacenter"
    zone = ["1", "2", "3"]
    nics = {
      "nic01" = {
        name = "ap01-nic"
        join_subnet_key = "subnet02"
        public_ip       = false
        lb_flag        = false
      },
      "nic01-2" = {
        name = "ap01-nic-2"
        join_subnet_key = "subnet02"
        public_ip       = false
        lb_flag        = false
      }
    }
  },
  "db01" = {
    size     = "Standard_B2as_v2"
    os_image = "2022-Datacenter"
    zone = ["1", "2", "3"]
    nics = {
      "nic02" = {
        name = "db01-nic"
        join_subnet_key = "subnet02"
        public_ip       = false
        lb_flag        = false
      }
    }
  },
  "web01" = {
    size     = "Standard_B2as_v2"
    os_image = "2022-Datacenter"
    zone = ["1", "2", "3"]
    nics = {
      "nic03" = {
        name = "web01-nic"
        join_subnet_key = "subnet01"
        public_ip       = false
        lb_flag        = true
      }
    }
  },
  "web02" = {
    size     = "Standard_B2as_v2"
    os_image = "2022-Datacenter"
    zone = ["1", "2", "3"]
    nics = {
      "nic04" = {
        name = "web02-nic"
        join_subnet_key = "subnet01"
        public_ip       = false
      }
    }
  }
}

#Bastionの設定
#Bastionについては複数作成する想定はないためmapでの定義はしていません。
# bastion-address-prefix = "10.1.3.0/26"
# bastion-sku = "Basic"