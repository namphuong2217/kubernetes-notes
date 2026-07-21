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
echo "Verifying Question 13..."
echo "========================================"

check \
'kubectl get storageclass local-fast >/dev/null 2>&1' \
'StorageClass local-fast tồn tại'

check \
'[[ "$(kubectl get storageclass local-fast -o jsonpath="{.provisioner}")" == "rancher.io/local-path" ]]' \
'Provisioner đúng'

check \
'[[ "$(kubectl get storageclass local-fast -o jsonpath="{.volumeBindingMode}")" == "WaitForFirstConsumer" ]]' \
'volumeBindingMode đúng'

check \
'[[ "$(kubectl get storageclass local-fast -o jsonpath="{.metadata.annotations.storageclass\.kubernetes\.io/is-default-class}")" == "true" ]]' \
'local-fast là default'

check \
'[[ "$(kubectl get storageclass standard -o jsonpath="{.metadata.annotations.storageclass\.kubernetes\.io/is-default-class}")" != "true" ]]' \
'standard không còn là default'

check \
'[[ $(kubectl get storageclass -o json | jq "[.items[] | select(.metadata.annotations[\"storageclass.kubernetes.io/is-default-class\"]==\"true\")] | length") -eq 1 ]]' \
'Chỉ có một StorageClass mặc định'

echo

if [ $FAILED -eq 0 ]; then
    echo "========================================"
    echo "✅ Question 13 PASSED"
    echo "========================================"
    exit 0
else
    echo "========================================"
    echo "❌ Question 13 FAILED"
    echo "========================================"
    exit 1
fi