variable "cloud_id" {
  description = "Yandex Cloud cloud id."
  type        = string
}

variable "folder_id" {
  description = "Yandex Cloud folder id."
  type        = string
}

variable "zone" {
  description = "Availability zone."
  type        = string
  default     = "ru-central1-a"
}

variable "project_name" {
  description = "Project name prefix for resources."
  type        = string
  default     = "future-2-0"
}

variable "environment" {
  description = "Environment name."
  type        = string
  default     = "dev"
}

variable "vm_image_family" {
  description = "Base VM image family."
  type        = string
  default     = "ubuntu-2204-lts"
}

variable "disk_type" {
  description = "Default disk type."
  type        = string
  default     = "network-ssd"
}

variable "ssh_user" {
  description = "Default SSH user."
  type        = string
  default     = "ubuntu"
}

variable "ssh_public_key" {
  description = "SSH public key for VM access."
  type        = string
}

variable "admin_cidrs" {
  description = "CIDR blocks allowed to connect to bastion via SSH."
  type        = list(string)
}

variable "public_subnet_cidr" {
  description = "Public subnet CIDR."
  type        = string
  default     = "10.10.10.0/24"
}

variable "private_subnet_cidr" {
  description = "Private subnet CIDR."
  type        = string
  default     = "10.10.20.0/24"
}

variable "bastion_cores" {
  type    = number
  default = 2
}

variable "bastion_memory" {
  type    = number
  default = 2
}

variable "bastion_boot_disk_size" {
  type    = number
  default = 20
}

variable "portal_cores" {
  type    = number
  default = 2
}

variable "portal_memory" {
  type    = number
  default = 4
}

variable "portal_boot_disk_size" {
  type    = number
  default = 30
}

variable "integration_cores" {
  type    = number
  default = 2
}

variable "integration_memory" {
  type    = number
  default = 4
}

variable "integration_boot_disk_size" {
  type    = number
  default = 30
}

variable "data_platform_cores" {
  type    = number
  default = 4
}

variable "data_platform_memory" {
  type    = number
  default = 16
}

variable "data_platform_boot_disk_size" {
  type    = number
  default = 50
}

variable "data_platform_data_disk_size" {
  type    = number
  default = 200
}

variable "observability_cores" {
  type    = number
  default = 2
}

variable "observability_memory" {
  type    = number
  default = 4
}

variable "observability_boot_disk_size" {
  type    = number
  default = 50
}

variable "preemptible" {
  description = "Use preemptible VMs for cost optimization in non-prod."
  type        = bool
  default     = false
}
