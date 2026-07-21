#!/bin/bash

set -e

echo "========================================"
echo "Preparing Question 8..."
echo "========================================"

echo

# Cluster must be Ready
kubectl get nodes

echo

# Ensure no common CNI is installed
if kubectl get ns calico-system >/dev/null 2>&1; then
    echo "ERROR: Calico is already installed."
    echo
    echo "Please use a fresh Kubernetes cluster."
    exit 1
fi

if kubectl get ns kube-flannel >/dev/null 2>&1; then
    echo "ERROR: Flannel is already installed."
    echo
    echo "Please use a fresh Kubernetes cluster."
    exit 1
fi

echo "✓ Fresh cluster detected."
echo
echo "You may now start Question 8."