# Cloudflare Kubernetes Ingress Terraform Module

This Terraform module is used to create a deployed Kubernetes ingress via Helm and Cloudflared. It also creates a Kubernetes secret for the cluster with the information of the Cloudflare tunnel and connection information.

## Features

- Deploys Kubernetes ingress using Helm
- Integrates with Cloudflare for secure and fast DNS resolution
- Creates Kubernetes secret with Cloudflare tunnel information
- Configurable parameters for customization

## Usage

```hcl
module "cloudflare_ingress" {
    source = "path_to_this_module"

    # Add your configuration parameters here
}
```

## Requirements

- Terraform >= 0.12
- Helm provider
- Kubernetes cluster
- Cloudflare account

## Inputs

| Name          | Description                           | Type   | Default | Required |
|---------------|---------------------------------------|--------|---------|----------|
| `example_var` | Example variable description          | string | `""`    | no       |

## Outputs

| Name          | Description                           |
|---------------|---------------------------------------|
| `example_out` | Example output description            |

## Authors

This module is maintained by the contributors at [Willberto.biz](https://willberto.biz).

## License

This project is licensed under the MIT License.