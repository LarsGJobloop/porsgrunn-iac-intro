# Infrastructure as Code

> *Infrastructure is now just a well-defined shopping list and recipe.*

Infrastructure as Code is the set of tooling that we use for defining, provisioning and configuring resources. It's used instead of Graphical User Interfaces as it allows us to co-locate, version and manage changes to them through standardized flows (usually Git).

It’s used for a wide range of elements, from low-level hardware resources provided by cloud vendors to high-level SaaS services managed by external providers.

Usage (but not limited to):

- Server provisioning and configuration
- Identity and access management (IAM) and associated metadata
- Software-as-a-Service (SaaS) products like GitHub and associated accounts

> [!NOTE]
>
> While many providers support managing resources through APIs, not all do. Mileage may vary, though most larger and established ones provide API access.

## Provider Access Credentials (API Tokens)

Nothing is free (unless your the product) and when we use tools outside of the traditional GUIs, we need a way to authenticate with the providers. This is usually done through going to their portals, registering a user and then extracting an API token, usually located inside some form of developer section.

> [!IMPORTANT]
>
> This token acts as both your username and password and must be handled securely. If it ever gets committed to a repository, revoke it **immediately**. Failure to do so is highly likely to incur financial or legal costs.

### Secure handling of secrets

There are several ways to handle these securely. Here are three approaches:

- Cloud Vaults: Costs money, but allows device-independent access and sharing across teams. Examples:
  - [HashiCorp Vault](https://www.hashicorp.com/en/products/vault)
  - [1Password](https://1password.com/) (Personal recommandation for private use and smaller teams)
- Sealed secrets: Embed **encrypted** secrets inside the repository for co-location and easy versioning. Still needs an outside key to gain access.
  - [Sops](https://github.com/getsops/sops) + [Age](https://github.com/FiloSottile/age)
- Physical Enclaves: Secure, but hard to swap, limited sharing.
  - Yubikey

## Command Shortlist

- Initialize a project and download any dependencies:

    ```sh
    terraform init
    ````

- Create the defined resources:

    ```sh
    terraform apply
    ````

- Destroy all defined resources:

    ```sh
    terraform destroy
    ```

## Terraform Major concepts

This is a short intro to the most important elements when working with Terraform. There are far more, but those are optional/intermediate. Much of the complexity lies in configuring the resources themselves, and that heavily depends on the specific resources being provisioned.

### Providers

These are the vendors who provide resources for you to configure. Needs to be added explicitly, usually along with a token to gain access. If these are changed you need to rerun `terraform init`.

```tf
terraform {
  # The list of all vendors/providers for this module
  required_providers {
    github = {
      source = "integrations/github"
      version = "6.6.0"
    }
  }
}

# A block for configuring one of them
provider "github" {
  token = var.github_token
}
````

### Resources

Each providers gives access to their own set of resources. Reference their documentation for how to configure them.

```tf
resource "github_repository" "example_repo" {
  name        = "example-repo"
  description = "My example GitHub repo managed by Terraform"
  visibility  = "private"
}
````

### Variables (inputs, arguments)

Some data is not safe to store in version control unencrypted, or you might want to allow others to pass in configuration when instantiating resources.

```tf
variable "key_to_use" {
  description = "A handy description so others know what it is"
  type = string # Terraform supports primitive types like string, number, bool, as well as complex types like list and map.
  sensitive = true # If the value is sensitive (access credentials, etc) hide it from all logs
}
```

#### Autoload variables

There are multiple options for passing in any variables defined, one way is to just `terraform apply` and enter them in the terminal. That might get tedious, so you can create a file referencing them instead. These will be automatically used by the Terraform CLI.

```tfvars
# Inside a file (exact name is important)
# ./.auto.tfvars
github_token = "some-unique-token-you-have"
hetzner_token = "another-token-for-the-system-to-use"
```

### Outputs (return values)

When creating resources, you are likely to want to return some information for these, be that IP addresses or URLs, even cost estimates.

```tf
output "name_of_output" {
  description = "A clear description of what this output represents"
  value = resource_type.custom_name.exact_value_you_want
  sensitive = true # If the value is sensitive (access credentials, etc) hide it from all logs
}
```

## References

- [Terraform Tutorials](https://developer.hashicorp.com/terraform/tutorials): Most commonly used tool
- [Terraform Documentation](https://developer.hashicorp.com/terraform/docs): Official documentation reference
- [Terraform Registry](https://registry.terraform.io/): Registry for available providers
- [OpenTofu](https://opentofu.org/): Open Source fork of Terraform.
