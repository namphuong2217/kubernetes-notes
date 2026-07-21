#!/bin/bash

set +e

FAILED=0

check() {
    if eval "$1"; then
        echo "✅ $2"
    else
        echo "❌ $2"
        FAILED=1
    fi
}

echo "========================================"
echo "Verifying Question 6..."
echo "========================================"

check \
'[[ -f /root/cm-crds.yaml ]]' \
'cm-crds.yaml exists'

check \
'grep -q "certificates.cert-manager.io" /root/cm-crds.yaml' \
'Certificate CRD listed'

check \
'grep -q "issuers.cert-manager.io" /root/cm-crds.yaml' \
'Issuer CRD listed'

check \
'grep -q "clusterissuers.cert-manager.io" /root/cm-crds.yaml' \
'ClusterIssuer CRD listed'

check \
'[[ -f /root/dnsnames.yaml ]]' \
'dnsnames.yaml exists'

check \
'grep -qi "dnsNames" /root/dnsnames.yaml' \
'dnsNames field documented'

check \
'grep -qi "domain" /root/dnsnames.yaml || grep -qi "dns" /root/dnsnames.yaml' \
'dnsNames description found'

echo

if [ $FAILED -eq 0 ]; then
    echo "========================================"
    echo "✅ Question 6 PASSED"
    echo "========================================"
    exit 0
else
    echo "========================================"
    echo "❌ Question 6 FAILED"
    echo "========================================"
    exit 1
fi