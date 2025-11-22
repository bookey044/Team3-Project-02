/////////////////////////////////////////////////////
//
// --- 지역 변수 설정 ---
//
/////////////////////////////////////////////////////

locals {
  size    = "Standard_B2s"
  type    = "Standard_LRS"
  user    = "team3"
  keypath = "./id_rsa.pub"
  rw      = "ReadWrite"
  publish = "resf"
  offer   = "rockylinux-x86_64"
  sku     = "9-lvm"
  ver     = "9.3.20231113"
  pname   = "9-lvm"
}

/////////////////////////////////////////////////////
//
// --- 전역 변수 정의 시작 ---
//
/////////////////////////////////////////////////////

variable "subid" {
  type      = string
  default   = "99b79efe-ebd6-468c-b39f-5669acb259e1"
  sensitive = true
}

variable "loca" {
  type        = string
  default     = "KoreaCentral"
}

variable "static" {
  type        = string
  default     = "Static"
}

variable "dynamic" {
  type        = string
  default     = "Dynamic"
}

variable "stand" {
  type        = string
  default     = "Standard"
}

variable "ip4" {
  type        = string
  default     = "IPv4"
}