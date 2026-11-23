#!/bin/bash

# ============================================================
# Kubernetes Worker Node Setup
# ============================================================

# Kubernetes version
KUBE_VERSION="1.37.0-1.1"

# Pause image version used by containerd
PAUSE_VERSION="3.10"

# Worker node private IP, remember to change this to be your worker node IP-address.
NODE_IP="<Worker Node private IP-address>"

# Control plane private IP, remember to change this to be your controller node IP-address.
CONTROL_PLANE_IP="<Controller Node private IP-address>"

# ============================================================
# Update packages
# ============================================================

sudo apt-get update

# ============================================================
# Containerd
# ============================================================

sudo apt-get install -y containerd

# Generate default containerd configuration,
# enable systemd cgroups, and set Kubernetes pause image.
# Containerd refers to it as the sandbox image.
# It is a small helper container that Kubernetes uses internally
# to create and manage Pods.

containerd config default \
| sed 's/SystemdCgroup = false/SystemdCgroup = true/' \
| sed "s|sandbox_image = \".*\"|sandbox_image = \"registry.k8s.io/pause:${PAUSE_VERSION}\"|" \
| sudo tee /etc/containerd/config.toml >/dev/null

sudo systemctl restart containerd

# ============================================================
# Disable swap
# ============================================================

sudo swapoff -a

# ============================================================
# Kubernetes repository
# ============================================================

sudo apt-get install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  gpg

sudo mkdir -p -m 755 /etc/apt/keyrings

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.37/deb/Release.key \
| sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.37/deb/ /" \
| sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update

# ============================================================
# Install Kubernetes components
# ============================================================

sudo apt-get install -y \
  kubelet=$KUBE_VERSION \
  kubeadm=$KUBE_VERSION \
  kubectl=$KUBE_VERSION

sudo apt-mark hold kubelet kubeadm kubectl

# ============================================================
# Enable IP forwarding
# ============================================================

sudo sysctl -w net.ipv4.ip_forward=1

sudo tee /etc/sysctl.d/99-kubernetes.conf >/dev/null <<EOF
net.ipv4.ip_forward=1
EOF

sudo sysctl --system

# ============================================================
# Install CNI plugins
# ============================================================

sudo mkdir -p /opt/cni/bin

curl -L \
https://github.com/containernetworking/plugins/releases/download/v1.9.1/cni-plugins-linux-amd64-v1.9.1.tgz \
| sudo tar -C /opt/cni/bin -xz

sudo ln -sf /opt/cni/bin /usr/lib/cni

# ============================================================
# Configure kubelet to use private IP
# ============================================================

echo "KUBELET_EXTRA_ARGS=--node-ip=${NODE_IP}" \
| sudo tee /etc/default/kubelet

sudo systemctl daemon-reload
sudo systemctl restart kubelet

# ============================================================
# Verify connectivity to control plane
# ============================================================

nc -vz ${CONTROL_PLANE_IP} 6443

# ============================================================
# Information
# ============================================================

echo
echo "========================================"
echo "Worker node prepared"
echo "========================================"
echo "Kubernetes version : ${KUBE_VERSION}"
echo "Pause image version: ${PAUSE_VERSION}"
echo "Worker IP          : ${NODE_IP}"
echo "Control Plane IP   : ${CONTROL_PLANE_IP}"
echo

echo "Next step:"
echo "1. On the control plane node, run:"
echo
echo "   sudo kubeadm token create --print-join-command"
echo
echo "2. Copy the generated kubeadm join command"
echo "3. Execute it on this worker node"
echo
