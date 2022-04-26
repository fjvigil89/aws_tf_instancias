output "odoo12_dns" {
  description = "ages_chile"
  value       = aws_eip.odoo12.public_dns
}
output "odoo14_dns" {
  description = "ages_supi"
  value       = aws_eip.odoo14.public_dns
}