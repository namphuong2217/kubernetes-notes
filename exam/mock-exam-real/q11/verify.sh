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
echo "Verifying Question 11..."
echo "========================================"

check \
'kubectl get svc echo-svc -n echo-lab >/dev/null 2>&1' \
'Service exists'

check \
'[[ "$(kubectl get svc echo-svc -n echo-lab -o jsonpath="{.spec.type}")" == "NodePort" ]]' \
'Service type is NodePort'

check \
'[[ "$(kubectl get svc echo-svc -n echo-lab -o jsonpath="{.spec.ports[0].port}")" == "9090" ]]' \
'Service port is 9090'

check \
'kubectl get ingress echo-ing -n echo-lab >/dev/null 2>&1' \
'Ingress exists'

check \
'[[ "$(kubectl get ingress echo-ing -n echo-lab -o jsonpath="{.spec.rules[0].host}")" == "echo.example.local" ]]' \
'Ingress hostname is correct'

check \
'[[ "$(kubectl get ingress echo-ing -n echo-lab -o jsonpath="{.spec.rules[0].http.paths[0].path}")" == "/ping" ]]' \
'Ingress path is correct'

check \
'[[ "$(kubectl get ingress echo-ing -n echo-lab -o jsonpath="{.spec.rules[0].http.paths[0].backend.service.name}")" == "echo-svc" ]]' \
'Ingress backend service is correct'

check \
'[[ "$(kubectl get ingress echo-ing -n echo-lab -o jsonpath="{.spec.rules[0].http.paths[0].backend.service.port.number}")" == "9090" ]]' \
'Ingress backend port is correct'

check \
'kubectl rollout status deployment/echo-server -n echo-lab >/dev/null 2>&1' \
'Deployment is ready'

echo

NODEPORT=$(kubectl get svc echo-svc -n echo-lab -o jsonpath='{.spec.ports[0].nodePort}')
NODEIP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')

if curl -fs "http://${NODEIP}:${NODEPORT}/ping" >/dev/null 2>&1; then
    echo "✅ NodePort truy cập thành công"
else
    echo "⚠️ Không thể kiểm tra NodePort (phụ thuộc môi trường lab)"
fi

echo

if [ $FAILED -eq 0 ]; then
    echo "========================================"
    echo "✅ Question 11 PASSED"
    echo "========================================"
    exit 0
else
    echo "========================================"
    echo "❌ Question 11 FAILED"
    echo "========================================"
    exit 1
fi