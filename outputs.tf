output "client_id" {
  description = "Map of OAuth client IDs for each host-based authentication configuration."
  value = {
    for hostname, _ in var.host_based_auth : hostname => try(
      aws_cognito_user_pool_client.host_based[hostname].id,
      (local.create_user_pool ? aws_cognito_user_pool_client.user_pool[0].id : "")
    )
  }
}

output "client_secret" {
  description = "Map of OAuth client secrets for each host-based authentication configuration."
  value = {
    for hostname, _ in var.host_based_auth : hostname => sensitive(try(
      aws_cognito_user_pool_client.host_based[hostname].client_secret,
      (local.create_user_pool ? aws_cognito_user_pool_client.user_pool[0].client_secret : "")
    ))
  }
}

output "domain" {
  description = "Map of authentication domains for each host-based configuration."
  value = {
    for hostname, _ in var.host_based_auth : hostname => try(
      aws_cognito_user_pool_domain.host_based[hostname].domain,
      (local.create_user_pool ? aws_cognito_user_pool_domain.user_pool[0].domain : "")
    )
  }
}

output "user_pool_id" {
  description = "Map of user pool IDs for each host-based authentication configuration."
  value = {
    for hostname, _ in var.host_based_auth : hostname => try(
      aws_cognito_user_pool.host_based[hostname].id,
      (local.create_user_pool ? aws_cognito_user_pool.user_pool[0].id : "")
    )
  }
}
