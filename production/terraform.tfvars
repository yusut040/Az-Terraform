#このファイルはTerraformの変数定義ファイルです。
#各リソースの設定値をここに記載します。
#ネーミングルールに関してはMicrosoft社公式の命名規則に則っています。
# https://learn.microsoft.com/ja-jp/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming
#MAPのキーがリソース名の一部となります。

#アプリケーション名、サブスクリプションの目的
system-name = "ytoyoda8"

vnets = {
  "01" = {
    address_prefix = "10.1.0.0/16"
  }
}

subnets = {
  "01" = {
    address_prefix = "10.1.1.0/24"
  },
  "02" = {
    address_prefix = "10.1.2.0/24"
  }
}

#VMのリソース名はvm-<mapのキー>-prod-<番号>とする
#VMのサイズはStandard_B1s、Standard_B2s、Standard_B4sなどを指定
#OSイメージは2019-Datacenter、2022-Datacenterなどを指定
windows_vms = {
  "ap01" = {
    size     = "Standard_B2as_v2"
    os_image = "2022-Datacenter"
  },
  "db01" = {
    size     = "Standard_B2as_v2"
    os_image = "2022-Datacenter"
  },
  "web01" = {
    size     = "Standard_B2as_v2"
    os_image = "2022-Datacenter"
  }
}

vm_nics = {
  "ap01" = {
    name = "vm-prod-01-nic"
    subnet_key = "02"
  },
  "db01" = {
    name = "vm-prod-02-nic"
    subnet_key = "02"
  },
  "web01" = {
    name = "vm-prod-03-nic"
    subnet_key = "01"
  }
}
