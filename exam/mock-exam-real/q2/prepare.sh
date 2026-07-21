#!/bin/bash

set -e

echo "[INFO] Cleaning previous environment..."

rm -f /root/argocd-template.yaml

helm uninstall argocd -n gitops-ns >/dev/null 2>&1 || true

kubectl delete namespace gitops-ns --ignore-not-found=true >/dev/null 2>&1 || true

kubectl delete crd applications.argoproj.io \
  applicationsets.argoproj.io \
  appprojects.argoproj.io \
  argocdextensions.argoproj.io \
  --ignore-not-found=true >/dev/null 2>&1 || true

rm -rf /tmp/argo-cd

echo "[INFO] Adding Helm repository..."

helm repo add argo-helm https://argoproj.github.io/argo-helm >/dev/null 2>&1 || true

helm repo update >/dev/null

echo "[INFO] Downloading Argo CD chart..."

helm pull argo-helm/argo-cd \
  --version 7.9.0 \
  --untar \
  --untardir /tmp

echo "[INFO] Installing Argo CD CRDs..."

kubectl apply -f /tmp/argo-cd/crds/

echo
echo "========================================"
echo "Question 2 is ready."
echo
echo "Current environment:"
echo "  ✓ Argo CD CRDs are pre-installed"
echo "  ✗ Namespace gitops-ns does not exist"
echo "  ✗ Helm release argocd does not exist"
echo "  ✗ /root/argocd-template.yaml does not exist"
echo
echo "Please start solving the lab."
echo "========================================"