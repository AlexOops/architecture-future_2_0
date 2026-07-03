terraform {
  required_version = ">= 1.5.0"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.130"
    }
  }
}

provider "yandex" {
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
}

locals {
  name_prefix = "${var.project_name}-${var.environment}"

  common_labels = {
    project     = var.project_name
    environment = var.environment
    managed_by  = "terraform"
  }

  ssh_metadata = {
    ssh-keys = "${var.ssh_user}:${var.ssh_public_key}"
  }
}

data "yandex_compute_image" "ubuntu" {
  family = var.vm_image_family
}

resource "yandex_vpc_network" "this" {
  name        = "${local.name_prefix}-network"
  description = "Network for Future 2.0 data platform."
  labels      = local.common_labels
}

resource "yandex_vpc_gateway" "nat" {
  name        = "${local.name_prefix}-nat-gateway"
  description = "Shared egress NAT gateway for private subnet."
  labels      = local.common_labels

  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "private" {
  name       = "${local.name_prefix}-private-rt"
  network_id = yandex_vpc_network.this.id
  labels     = local.common_labels

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat.id
  }
}

resource "yandex_vpc_subnet" "public" {
  name           = "${local.name_prefix}-public-subnet"
  zone           = var.zone
  network_id     = yandex_vpc_network.this.id
  v4_cidr_blocks = [var.public_subnet_cidr]
  labels         = local.common_labels
}

resource "yandex_vpc_subnet" "private" {
  name           = "${local.name_prefix}-private-subnet"
  zone           = var.zone
  network_id     = yandex_vpc_network.this.id
  v4_cidr_blocks = [var.private_subnet_cidr]
  route_table_id = yandex_vpc_route_table.private.id
  labels         = local.common_labels
}

resource "yandex_vpc_security_group" "bastion" {
  name        = "${local.name_prefix}-bastion-sg"
  description = "Allow SSH to bastion from admin IPs."
  network_id  = yandex_vpc_network.this.id
  labels      = local.common_labels

  ingress {
    description    = "SSH from admin CIDRs."
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = var.admin_cidrs
  }

  egress {
    description    = "Allow outbound traffic."
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "portal" {
  name        = "${local.name_prefix}-portal-sg"
  description = "Allow HTTP/HTTPS to self-service portal."
  network_id  = yandex_vpc_network.this.id
  labels      = local.common_labels

  ingress {
    description    = "HTTP from internet."
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "HTTPS from internet."
    protocol       = "TCP"
    port           = 443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "SSH from bastion subnet."
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = [var.public_subnet_cidr]
  }

  egress {
    description    = "Allow outbound traffic."
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "private_services" {
  name        = "${local.name_prefix}-private-services-sg"
  description = "Security group for private integration, data and observability services."
  network_id  = yandex_vpc_network.this.id
  labels      = local.common_labels

  ingress {
    description    = "SSH from bastion subnet."
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = [var.public_subnet_cidr]
  }

  ingress {
    description    = "Internal traffic from private subnet."
    protocol       = "ANY"
    v4_cidr_blocks = [var.private_subnet_cidr]
  }

  ingress {
    description    = "Application traffic from portal subnet."
    protocol       = "TCP"
    from_port      = 8000
    to_port        = 9000
    v4_cidr_blocks = [var.public_subnet_cidr]
  }

  egress {
    description    = "Allow outbound traffic through NAT."
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_compute_instance" "bastion" {
  name                      = "${local.name_prefix}-bastion"
  hostname                  = "${local.name_prefix}-bastion"
  platform_id               = "standard-v3"
  allow_stopping_for_update = true
  labels                    = local.common_labels

  resources {
    cores         = var.bastion_cores
    memory        = var.bastion_memory
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = var.bastion_boot_disk_size
      type     = var.disk_type
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.bastion.id]
  }

  scheduling_policy {
    preemptible = var.preemptible
  }

  metadata = local.ssh_metadata
}

resource "yandex_compute_instance" "portal" {
  name                      = "${local.name_prefix}-portal"
  hostname                  = "${local.name_prefix}-portal"
  platform_id               = "standard-v3"
  allow_stopping_for_update = true
  labels                    = local.common_labels

  resources {
    cores         = var.portal_cores
    memory        = var.portal_memory
    core_fraction = 50
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = var.portal_boot_disk_size
      type     = var.disk_type
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.portal.id]
  }

  scheduling_policy {
    preemptible = var.preemptible
  }

  metadata = local.ssh_metadata
}

resource "yandex_compute_instance" "integration" {
  name                      = "${local.name_prefix}-integration"
  hostname                  = "${local.name_prefix}-integration"
  platform_id               = "standard-v3"
  allow_stopping_for_update = true
  labels                    = local.common_labels

  resources {
    cores         = var.integration_cores
    memory        = var.integration_memory
    core_fraction = 50
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = var.integration_boot_disk_size
      type     = var.disk_type
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.private.id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.private_services.id]
  }

  scheduling_policy {
    preemptible = var.preemptible
  }

  metadata = local.ssh_metadata
}

resource "yandex_compute_disk" "data_platform_data" {
  name   = "${local.name_prefix}-data-platform-data-disk"
  type   = var.disk_type
  zone   = var.zone
  size   = var.data_platform_data_disk_size
  labels = local.common_labels
}

resource "yandex_compute_instance" "data_platform" {
  name                      = "${local.name_prefix}-data-platform"
  hostname                  = "${local.name_prefix}-data-platform"
  platform_id               = "standard-v3"
  allow_stopping_for_update = true
  labels                    = local.common_labels

  resources {
    cores         = var.data_platform_cores
    memory        = var.data_platform_memory
    core_fraction = 100
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = var.data_platform_boot_disk_size
      type     = var.disk_type
    }
  }

  secondary_disk {
    disk_id     = yandex_compute_disk.data_platform_data.id
    auto_delete = false
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.private.id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.private_services.id]
  }

  scheduling_policy {
    preemptible = var.preemptible
  }

  metadata = local.ssh_metadata
}

resource "yandex_compute_instance" "observability" {
  name                      = "${local.name_prefix}-observability"
  hostname                  = "${local.name_prefix}-observability"
  platform_id               = "standard-v3"
  allow_stopping_for_update = true
  labels                    = local.common_labels

  resources {
    cores         = var.observability_cores
    memory        = var.observability_memory
    core_fraction = 50
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = var.observability_boot_disk_size
      type     = var.disk_type
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.private.id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.private_services.id]
  }

  scheduling_policy {
    preemptible = var.preemptible
  }

  metadata = local.ssh_metadata
}
