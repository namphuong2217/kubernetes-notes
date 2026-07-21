#!/bin/bash

FAILED=0

check() {
    if eval "$2"; then
        echo "✅ $1"
    else
        echo "❌ $1"
        FAILED=1
    fi
}

echo "========================================"
echo "Kiểm tra kết quả..."
echo "========================================"

check "Deployment web-front tồn tại" \
'kubectl get deployment web-front -n svc-lab >/dev/null 2>&1'

check "Container node-app khai báo containerPort 3000" \
'kubectl get deployment web-front -n svc-lab -o jsonpath="{.spec.template.spec.containers[?(@.name==\"node-app\")].ports[0].containerPort}" | grep -qx 3000'

check "Service web-front-svc tồn tại" \
'kubectl get svc web-front-svc -n svc-lab >/dev/null 2>&1'

check "Service có type NodePort" \
'kubectl get svc web-front-svc -n svc-lab -o jsonpath="{.spec.type}" | grep -qx NodePort'

check "Service expose port 3000" \
'kubectl get svc web-front-svc -n svc-lab -o jsonpath="{.spec.ports[0].port}" | grep -qx 3000'

check "TargetPort là 3000" \
'kubectl get svc web-front-svc -n svc-lab -o jsonpath="{.spec.ports[0].targetPort}" | grep -qx 3000'

check "NodePort được cấp" \
'kubectl get svc web-front-svc -n svc-lab -o jsonpath="{.spec.ports[0].nodePort}" | grep -Eq "^[0-9]+$"'

check "Endpoints đã có Pod" \
'kubectl get endpoints web-front-svc -n svc-lab -o jsonpath="{.subsets[0].addresses[0].ip}" | grep -Eq "."'

echo

if [ "$FAILED" -eq 0 ]; then
    echo "========================================"
    echo "🎉 PASSED"
    echo "========================================"
    exit 0
else
    echo "========================================"
    echo "💥 FAILED"
    echo "========================================"
    exit 1
fi