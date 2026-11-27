#!/bin/bash

set -e

# Install dependencies
sudo apt update
sudo apt install -y curl

# Install Helm
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Verify installation
helm version
