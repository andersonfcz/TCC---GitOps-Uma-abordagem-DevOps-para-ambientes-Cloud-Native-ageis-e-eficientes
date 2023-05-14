variable "resource_group_name" {
  type    = string
  default = "tcc-unicarioca-gitops"
}

variable "azure_region" {
  type    = string
  default = "eastus"
}

variable "node_count" {
  type    = number
  default = 1
}

variable "vm_size" {
  type    = string
  default = "Standard_D2_v2"
}

variable "dns_name" {
  type    = string
  default = "tcc-unicarioca.tech"
}

variable "tenant_id" {
}

variable "subscription_id" {
}

variable "email" {

}

variable "db_name" {
  
}

variable "db_user" {
  
}

variable "db_password" {

}

variable "db_host" {
  
}