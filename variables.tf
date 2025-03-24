variable "region" {
  description = "AWS region to deploy to"
  type        = string
}

variable "stage_name" {
  description = "Stage name"
  type        = string
}

variable "domain_name" {
  description = "Domain name of the application"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all AWS resources created"
  type        = map(string)
}

variable "auth" {
  description = "Centralized user authentication configuration"
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
  description = "Host-based user authentication configuration"
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
  description = "List of containers to run in the ECS task"
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
  description = "List of identity providers to configure for user authentication"
  type = map(object({
    type              = string
    metadata_url      = string
    attribute_mapping = map(string)
  }))
  default = {}
}

variable "mail_sending" {
  description = "Value for the 'From' field in emails sent by the application"
  type = object({
    enabled      = bool
    from_address = optional(string)
  })

  default = {
    enabled = false
  }
}
