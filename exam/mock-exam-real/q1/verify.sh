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

check \
'kubectl get pvc redis-data -n redis-store >/dev/null 2>&1' \
"PVC redis-data exists"

check \
'[[ "$(kubectl get pv redis-pv -o jsonpath="{.status.phase}")" == "Bound" ]]' \
"PV is Bound"

check \
'[[ "$(kubectl get deploy redis -n redis-store -o jsonpath="{.spec.template.spec.volumes[0].persistentVolumeClaim.claimName}")" == "redis-data" ]]' \
"Deployment uses redis-data PVC"

check \
'[[ "$(kubectl get pod -n redis-store -l app=redis -o jsonpath="{.items[0].status.phase}")" == "Running" ]]' \
"Redis Pod is Running"

echo

if [ $FAILED -eq 0 ]; then
    echo "========================================"
    echo "✅ Question 1 PASSED"
    echo "========================================"
    exit 0
else
    echo "========================================"
    echo "❌ Question 1 FAILED"
    echo "========================================"
    exit 1
fi