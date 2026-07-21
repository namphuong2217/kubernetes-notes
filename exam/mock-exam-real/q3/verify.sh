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
echo "Verifying Question 3..."
echo "========================================"

check \
'kubectl get deploy apache-web >/dev/null 2>&1' \
'Deployment exists'

check \
'[[ $(kubectl get deploy apache-web -o jsonpath="{.spec.template.spec.containers[*].name}" | wc -w) -eq 2 ]]' \
'Deployment has two containers'

check \
'kubectl get deploy apache-web -o jsonpath="{.spec.template.spec.containers[1].name}" | grep -qx log-shipper' \
'Sidecar name is log-shipper'

check \
'kubectl get deploy apache-web -o jsonpath="{.spec.template.spec.containers[1].image}" | grep -qx busybox:stable' \
'Sidecar image is busybox:stable'

check \
'kubectl get deploy apache-web -o jsonpath="{.spec.template.spec.containers[1].command[*]}" | grep -q "tail -f /var/log/apache-web.log"' \
'Sidecar command is correct'

check \
'kubectl get deploy apache-web -o jsonpath="{.spec.template.spec.volumes[0].emptyDir}" >/dev/null 2>&1' \
'Shared emptyDir volume exists'

check \
'kubectl get deploy apache-web -o jsonpath="{.spec.template.spec.containers[0].volumeMounts[0].mountPath}" | grep -qx "/var/log"' \
'Main container mounts /var/log'

check \
'kubectl get deploy apache-web -o jsonpath="{.spec.template.spec.containers[1].volumeMounts[0].mountPath}" | grep -qx "/var/log"' \
'Sidecar mounts /var/log'

check \
'kubectl rollout status deployment/apache-web >/dev/null 2>&1' \
'Deployment rollout completed'

check \
'kubectl get pod -l app=apache-web -o jsonpath="{.items[0].status.containerStatuses[*].ready}" | grep -q "true true"' \
'Pod is READY 2/2'

check \
'kubectl logs deploy/apache-web -c log-shipper --tail=5 2>/dev/null | grep -q .' \
'Sidecar can read shared log'

echo

if [ $FAILED -eq 0 ]; then
    echo "========================================"
    echo "✅ Question 3 PASSED"
    echo "========================================"
    exit 0
else
    echo "========================================"
    echo "❌ Question 3 FAILED"
    echo "========================================"
    exit 1
fi