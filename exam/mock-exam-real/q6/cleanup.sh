#!/bin/bash

set +e

kubectl delete -f https://github.com/cert-manager/cert-manager/releases/download/v1.18.2/cert-manager.crds.yaml >/dev/null 2>&1

rm -f /root/cm-crds.yaml
rm -f /root/dnsnames.yaml

echo
echo "========================================"
echo "Question 6 cleaned."
echo "========================================"