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
| region | AWS region to deploy to | `string` | n/a | yes |
| stage_name | Stage name | `string` | n/a | yes |
| domain_name | Domain name of the application | `string` | n/a | yes |
| auth | Centralized user authentication configuration | `object` | `{}` | no |
| host_based_auth | Host-based user authentication configuration | `map(object)` | `{}` | no |
| identity_providers | List of identity providers to configure | `map(object)` | `{}` | no |
| mail_sending | Email sending configuration | `object` | `{ enabled = false }` | no |
| tags | Tags to apply to all AWS resources | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| user_pool_id | ID of the centralized user pool |
| user_pool_arn | ARN of the centralized user pool |
| user_pool_endpoint | Endpoint of the centralized user pool |
| host_based_user_pools | Map of host-based user pool IDs |
| host_based_user_pool_arns | Map of host-based user pool ARNs |
| host_based_user_pool_endpoints | Map of host-based user pool endpoints |

## License

MIT License. See LICENSE file for details. 