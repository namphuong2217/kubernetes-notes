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
echo "Verifying Question 12..."
echo "========================================"

check \
'kubectl get networkpolicy -n api-tier policy-3 >/dev/null 2>&1' \
'Đã apply đúng policy-3'

check \
'[[ $(kubectl get networkpolicy -n api-tier --no-headers | wc -l) -eq 1 ]]' \
'Chỉ có một NetworkPolicy được apply'

check \
'kubectl exec -n web-tier deploy/web-tier -- curl -s --max-time 5 api-tier-service.api-tier.svc.cluster.local:8080 | grep -q api-tier' \
'web-tier truy cập được api-tier:8080'

echo

if [ $FAILED -eq 0 ]; then
    echo "========================================"
    echo "✅ Question 12 PASSED"
    echo "========================================"
    exit 0
else
    echo "========================================"
    echo "❌ Question 12 FAILED"
    echo "========================================"
    exit 1
fi