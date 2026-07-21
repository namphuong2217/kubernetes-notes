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

#############################################
# ConfigMap
#############################################

check "ConfigMap chỉ cho phép TLSv1.2" \
'kubectl get configmap web-tls-cfg -n secure-web -o jsonpath="{.data.default\.conf}" | grep -q "ssl_protocols TLSv1.2;"'

#############################################
# hosts
#############################################

SERVICE_IP=$(kubectl get svc secure-web -n secure-web -o jsonpath='{.spec.clusterIP}')

check "/etc/hosts đã map hostname" \
"grep -q \"${SERVICE_IP}.*tls-check.k8s.local\" /etc/hosts"

#############################################
# TLS 1.3 phải fail
#############################################

check "TLSv1.3 bị từ chối" \
'curl -sk --tlsv1.3 https://tls-check.k8s.local >/dev/null 2>&1; test $? -ne 0'

#############################################
# TLS 1.2 phải thành công
#############################################

check "TLSv1.2 hoạt động" \
'curl -sk --tls-max 1.2 https://tls-check.k8s.local | grep -q "TLS OK"'

#############################################

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