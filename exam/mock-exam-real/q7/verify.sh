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
echo "Verifying Question 7..."
echo "========================================"

check \
'kubectl get priorityclass elevated-priority >/dev/null 2>&1' \
'PriorityClass exists'

check \
'[[ "$(kubectl get priorityclass elevated-priority -o jsonpath="{.value}")" == "899999" ]]' \
'PriorityClass value is highest existing value minus one'

check \
'[[ "$(kubectl get deploy log-collector -n workloads -o jsonpath="{.spec.template.spec.priorityClassName}")" == "elevated-priority" ]]' \
'Deployment uses elevated-priority'

check \
'kubectl rollout status deployment/log-collector -n workloads >/dev/null 2>&1' \
'Deployment rollout completed'

check \
'[[ $(kubectl get pods -n workloads -l app=log-collector --no-headers | grep Running | wc -l) -eq 1 ]]' \
'Pod is running'

echo

if [ $FAILED -eq 0 ]; then
    echo "========================================"
    echo "✅ Question 7 PASSED"
    echo "========================================"
    exit 0
else
    echo "========================================"
    echo "❌ Question 7 FAILED"
    echo "========================================"
    exit 1
fi