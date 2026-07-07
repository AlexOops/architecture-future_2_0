output "network_id" {
  description = "VPC network id."
  value       = yandex_vpc_network.this.id
}

output "public_subnet_id" {
  description = "Public subnet id."
  value       = yandex_vpc_subnet.public.id
}

output "private_subnet_id" {
  description = "Private subnet id."
  value       = yandex_vpc_subnet.private.id
}

output "nat_gateway_id" {
  description = "NAT gateway id."
  value       = yandex_vpc_gateway.nat.id
}

output "bastion_public_ip" {
  description = "Public IP address of bastion VM."
  value       = yandex_compute_instance.bastion.network_interface[0].nat_ip_address
}

output "portal_public_ip" {
  description = "Public IP address of self-service portal VM."
  value       = yandex_compute_instance.portal.network_interface[0].nat_ip_address
}

output "integration_private_ip" {
  description = "Private IP address of integration VM."
  value       = yandex_compute_instance.integration.network_interface[0].ip_address
}

output "data_platform_private_ip" {
  description = "Private IP address of data platform VM."
  value       = yandex_compute_instance.data_platform.network_interface[0].ip_address
}

output "observability_private_ip" {
  description = "Private IP address of observability VM."
  value       = yandex_compute_instance.observability.network_interface[0].ip_address
}

output "data_platform_disk_id" {
  description = "Additional data disk id for data platform."
  value       = yandex_compute_disk.data_platform_data.id
}
