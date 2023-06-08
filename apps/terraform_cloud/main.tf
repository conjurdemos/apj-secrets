
data "conjur_secret" "dbpass" {
  name = "data/vault/POV/Database-MySQL-database.pov.example.com-admin/password"
}

output "dbpass_output" {
  value = "${data.conjur_secret.dbpass.value}"
  
  # Must mark this output value as sensitive for Terraform Cloud,
  # because it's derived from a Conjur variable value that is declared
  # as sensitive.
  sensitive = true
}