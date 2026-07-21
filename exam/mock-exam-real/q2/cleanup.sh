#!/bin/bash

set -e

echo "[INFO] Removing Helm release..."

helm uninstall argocd -n gitops-ns >/dev/null 2>&1 || true

echo "[INFO] Removing namespace..."

kubectl delete namespace gitops-ns --ignore-not-found=true >/dev/null 2>&1 || true

echo "[INFO] Waiting for namespace deletion..."

kubectl wait \
  --for=delete namespace/gitops-ns \
  --timeout=60s >/dev/null 2>&1 || true

echo "[INFO] Removing Argo CD CRDs..."

kubectl delete crd applications.argoproj.io \
  applicationsets.argoproj.io \
  appprojects.argoproj.io \
  argocdextensions.argoproj.io \
  --ignore-not-found=true >/dev/null 2>&1 || true

echo "[INFO] Removing generated files..."

rm -f /root/argocd-template.yaml

rm -rf /tmp/argo-cd

echo
echo "========================================"
echo "Cleanup completed."
echo "========================================"