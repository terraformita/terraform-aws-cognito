variable "region" {
  description = "AWS region where resources will be created."
  type        = string
}

variable "stage_name" {
  description = "Name of the deployment stage used for resource naming."
  type        = string
}

variable "domain_name" {
  description = "Base domain name for the application and Cognito domains."
  type        = string
}

variable "tags" {
  description = "Key-value pairs to tag all created AWS resources."
  type        = map(string)
}

variable "auth" {
  description = "Configuration for centralized user authentication settings."
  type = object({
    allow_user_sign_up     = optional(bool, true)
    identity_providers     = optional(list(string), [])
    callback_path          = optional(string, "/oauth2/idpresponse")
    refresh_token_validity = optional(number, 1440)
    access_token_validity  = optional(number, 60)
    id_token_validity      = optional(number, 60)
  })
  default = {}
}

variable "host_based_auth" {
  description = "Configuration for host-based authentication with separate user pools."
  type = map(object({
    user_pool_id = optional(string, "centralized")
    automated    = optional(bool, true)

    service_endpoints = optional(object({
      userinfo = optional(string, "/oauth2/userinfo")
      logout   = optional(string, "/oauth2/logout")
    }), {})

    allow_user_sign_up = optional(bool, true)

    identity_providers = optional(list(string), [])

    callback_path = optional(string, "/oauth2/idpresponse")

    refresh_token_validity = optional(number, 1440)
    access_token_validity  = optional(number, 60)
    id_token_validity      = optional(number, 60)

    separate_user_pool = optional(bool, false)
  }))
  default = {}
}

variable "app_containers_map" {
  description = "Configuration for ECS containers including authentication settings."
  type = map(object({
    hostname       = optional(string)
    web_path       = optional(string, "/")
    web_entrypoint = optional(bool, false)
    protocol       = string
    image          = optional(string)
    port           = number
    cpu            = number
    memory         = number
    replicas       = optional(number, 1)

    deployment = optional(object({
      maximum_percent         = optional(number, 200)
      minimum_healthy_percent = optional(number, 100)
    }), {})

    env_vars    = optional(map(string))
    env_files   = optional(map(string))
    secret_vars = optional(map(string), {})
    disk_drive = optional(object({
      enabled = optional(bool, false)
      size_gb = optional(number, 10)
      path    = optional(string, "/mnt/data")
      uid     = optional(number, 2001)
      gid     = optional(number, 2001)
    }), {})

    health_check = optional(object({
      interval       = number
      timeout        = number
      path           = string
      response_codes = string
    }))

    accessible_cloud_storage = optional(list(string), [])

    user_auth = optional(object({
      automated = optional(bool, true)

      identity_providers = optional(list(string), [])
      callback_path      = optional(string, "/oauth2/idpresponse")

      refresh_token_validity = optional(number, 1440)
      access_token_validity  = optional(number, 60)
      id_token_validity      = optional(number, 60)

    }))
  }))
}

variable "identity_providers" {
  description = "Configuration for external identity providers like Google or SAML."
  type = map(object({
    type              = string
    metadata_url      = string
    attribute_mapping = map(string)
  }))
  default = {}
}

variable "mail_sending" {
  description = "Configuration for email sending via AWS SES."
  type = object({
    enabled      = bool
    from_address = optional(string)
  })

  default = {
    enabled = false
  }
}
