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
echo "Verifying Question 14..."
echo "========================================"

check \
'kubectl get nodes >/dev/null 2>&1' \
'API Server hoạt động'

check \
'kubectl -n kube-system get pods | grep kube-apiserver | grep Running >/dev/null' \
'kube-apiserver Running'

check \
'grep -- "--etcd-servers=https://192.168.1.20:2379" /etc/kubernetes/manifests/kube-apiserver.yaml >/dev/null' \
'Đúng endpoint etcd'

echo

if [ $FAILED -eq 0 ]; then
    echo "========================================"
    echo "✅ Question 14 PASSED"
    echo "========================================"
    exit 0
else
    echo "========================================"
    echo "❌ Question 14 FAILED"
    echo "========================================"
    exit 1
fi