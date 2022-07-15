output "odoo12_dns" {
  description = "ages_chile"
  value       = aws_eip.odoo12.public_dns
}
output "odoo14_dns" {
  description = "ages_supi"
  value       = aws_eip.odoo14.public_dns
}

output "odoo14_demo_dns" {
  description = "ages_supi_demo"
  value       = aws_eip.odoo14demo.public_dns
}

output "VA_clasificator_dev" {
  value = aws_eip.VA_clasificator_dev.public_dns
}
output "VA_prediction_dev" {
  value = aws_eip.VA_prediction_dev.public_dns
}