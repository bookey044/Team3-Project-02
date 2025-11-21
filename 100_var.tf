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

variable "stand" {
  type        = string
  default     = "Standard"
}

variable "ip4" {
  type        = string
  default     = "IPv4"
}