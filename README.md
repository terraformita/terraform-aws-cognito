# AWS Cognito Authentication Module

This Terraform module provides a comprehensive solution for implementing AWS Cognito authentication in your applications. It supports both centralized and host-based authentication configurations, with flexible options for identity providers and user management.

## Features

- **Flexible Authentication Models**:
  - Centralized user pool configuration
  - Host-based authentication with separate user pools
  - Support for multiple identity providers (OIDC, SAML)

- **Security Features**:
  - MFA support (Optional)
  - Password policies
  - Account recovery options
  - Token management
  - Email and phone verification

- **Integration Options**:
  - AWS SES integration for email sending
  - SMS authentication support
  - Lambda triggers for pre-signup
  - Customizable callback URLs

## Usage

```hcl
module "cognito_auth" {
  source = "your-registry/terraform-aws-cognito"

  region     = "us-west-2"
  stage_name = "prod"
  domain_name = "example.com"

  auth = {
    allow_user_sign_up = true
    callback_path     = "/oauth2/idpresponse"
  }

  host_based_auth = {
    "app1" = {
      separate_user_pool = true
      allow_user_sign_up = true
      callback_path     = "/auth/callback"
    }
  }

  identity_providers = {
    "google" = {
      type              = "Google"
      metadata_url      = "https://accounts.google.com/.well-known/openid-configuration"
      attribute_mapping = {
        "email"    = "email"
        "username" = "sub"
      }
    }
  }

  mail_sending = {
    enabled      = true
    from_address = "noreply@example.com"
  }

  tags = {
    Environment = "production"
    Project     = "my-app"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0.0 |
| aws | >= 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 4.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| region | AWS region where resources will be created. | `string` | n/a | yes |
| stage_name | Name of the deployment stage used for resource naming. | `string` | n/a | yes |
| domain_name | Base domain name for the application and Cognito domains. | `string` | n/a | yes |
| auth | Configuration for centralized user authentication settings. | `object` | `{}` | no |
| host_based_auth | Configuration for host-based authentication with separate user pools. | `map(object)` | `{}` | no |
| identity_providers | Configuration for external identity providers like Google or SAML. | `map(object)` | `{}` | no |
| mail_sending | Configuration for email sending via AWS SES. | `object` | `{ enabled = false }` | no |
| tags | Key-value pairs to tag all created AWS resources. | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| client_id | Map of OAuth client IDs for each host-based authentication configuration. |
| client_secret | Map of OAuth client secrets for each host-based authentication configuration. |
| domain | Map of authentication domains for each host-based configuration. |
| user_pool_id | Map of user pool IDs for each host-based authentication configuration. |

## License

MIT License. See LICENSE file for details. 