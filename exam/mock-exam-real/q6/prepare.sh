#!/bin/bash

set -e

echo "Cleaning previous environment..."

rm -f /root/cm-crds.yaml
rm -f /root/dnsnames.yaml

kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.18.2/cert-manager.crds.yaml >/dev/null

echo
echo "========================================"
echo "Question 6 environment is ready."
echo "========================================"