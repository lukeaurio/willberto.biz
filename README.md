# ghost.willberto.biz

This repository contains the setup and configuration for Google Cloud resources for the site [ghost.willberto.biz](http://ghost.willberto.biz).

## Overview

This project sets up the necessary Google Cloud resources to host and manage the site ghost.willberto.biz. The setup includes:
- Google Cloud Storage (GCS) for static assets
- Google Kubernetes Engine (GKE) for hosting the Ghost application
- Google Cloud DNS for domain management


4. **Deploy the application:**
    - Follow the deployment scripts and instructions provided in the `deploy` directory.\
    - git actions help comes from this article [here](https://alexanderhose.com/how-to-integrate-github-actions-with-google-cloud-platform/)

## Development Setup

### Pre-commit Hook (OpenTofu formatting)

Before committing, ensure [OpenTofu](https://opentofu.org/docs/intro/install/) is installed:

```sh
tofu --version
```

Then install the pre-commit hook to auto-format Tofu/Terraform files on every commit:

```sh
printf '%s\n' '#!/usr/bin/env sh' 'set -e' 'if ! command -v tofu >/dev/null 2>&1; then echo "Error: opentofu (tofu) is not installed. See https://opentofu.org/docs/intro/install/" >&2; exit 1; fi' 'tofu fmt --recursive' > .git/hooks/pre-commit && chmod +x .git/hooks/pre-commit
```

This hook will:
1. Verify `tofu` is installed before proceeding.
2. Recursively format all `.tf` files using `tofu fmt`.

## Contributing

Contributions are welcome! Please submit a pull request or open an issue to discuss any changes.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contact

For any questions or support, please contact [support@willberto.biz](mailto:support@willberto.biz).