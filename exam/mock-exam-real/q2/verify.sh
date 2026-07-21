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
echo "Verifying Question 2..."
echo "========================================"

#
# Task 1
#
check \
'helm repo list | awk "{print \$1}" | grep -qx "argo-helm"' \
'Helm repository "argo-helm" exists'

#
# Task 2
#
check \
'kubectl get namespace gitops-ns >/dev/null 2>&1' \
'Namespace "gitops-ns" exists'

#
# Task 3
#
check \
'[[ -s /root/argocd-template.yaml ]]' \
'Template file exists'

#
# Task 4
#
check \
'[[ $(grep -c "^kind: CustomResourceDefinition" /root/argocd-template.yaml 2>/dev/null) -eq 0 ]]' \
'Template does not contain CRDs'

#
# Task 5
#
check \
'helm list -n gitops-ns -q | grep -qx argocd' \
'Helm release "argocd" installed'

#
# Task 6
#
check \
'helm list -n gitops-ns | grep "argo-cd-7.9.0" >/dev/null 2>&1' \
'Chart version is 7.9.0'

#
# Task 7
#
check \
'kubectl get pods -n gitops-ns --no-headers 2>/dev/null | grep -q .' \
'Pods created'

#
# Task 8
#
check \
'kubectl get crd applications.argoproj.io >/dev/null 2>&1' \
'Argo CD CRDs exist'

echo

if [ $FAILED -eq 0 ]; then
    echo "========================================"
    echo "✅ Question 2 PASSED"
    echo "========================================"
    exit 0
else
    echo "========================================"
    echo "❌ Question 2 FAILED"
    echo "========================================"
    exit 1
fi