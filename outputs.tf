output "auth" {
  description = "Authentication configuration for each container including client IDs, secrets, domains and user pool IDs."
  value = {
    for name, container in var.app_containers_map : name => {
      client_id = try(
        aws_cognito_user_pool_client.endpoint_centralized[name].id,
        try(
          aws_cognito_user_pool_client.host_based[container.hostname].id,
          (local.create_user_pool ? aws_cognito_user_pool_client.user_pool[0].id : "")
        )
      )
      client_secret = sensitive(try(
        aws_cognito_user_pool_client.endpoint_centralized[name].client_secret,
        try(
          aws_cognito_user_pool_client.host_based[container.hostname].client_secret,
          (local.create_user_pool ? aws_cognito_user_pool_client.user_pool[0].client_secret : "")
        )
      ))
      user_pool_id = try(
        contains(local.host_based_user_pools, container.hostname),
        false
        ) ? aws_cognito_user_pool.host_based[container.hostname].id : (
        local.create_user_pool ? aws_cognito_user_pool.user_pool[0].id : ""
      )
      domain = try(
        contains(local.host_based_user_pools, container.hostname),
        false
        ) ? aws_cognito_user_pool_domain.host_based[container.hostname].domain : (
        local.create_user_pool ? aws_cognito_user_pool_domain.user_pool[0].domain : ""
      )
    }
  }
}
