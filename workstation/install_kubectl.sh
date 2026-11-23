#!/bin/bash

set -e

echo "Updating package index..."
sudo apt-get update

echo "Installing prerequisites..."
sudo apt-get install -y curl ca-certificates apt-transport-https

echo "Adding Kubernetes repository key..."
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.34/deb/Release.key \
  | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo "Adding Kubernetes repository..."
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.34/deb/ /' \
  | sudo tee /etc/apt/sources.list.d/kubernetes.list

echo "Updating package index..."
sudo apt-get update

echo "Installing kubectl..."
sudo apt-get install -y kubectl

echo "Kubectl version:"
kubectl version --client
