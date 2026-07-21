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
echo "Verifying Question 10..."
echo "========================================"

check \
'kubectl get gateway api-gateway >/dev/null 2>&1' \
'Gateway exists'

check \
'[[ "$(kubectl get gateway api-gateway -o jsonpath="{.spec.gatewayClassName}")" == "nginx-gw" ]]' \
'GatewayClass is nginx-gw'

check \
'[[ "$(kubectl get gateway api-gateway -o jsonpath="{.spec.listeners[0].protocol}")" == "HTTPS" ]]' \
'Listener protocol is HTTPS'

check \
'[[ "$(kubectl get gateway api-gateway -o jsonpath="{.spec.listeners[0].port}")" == "443" ]]' \
'Listener port is 443'

check \
'[[ "$(kubectl get gateway api-gateway -o jsonpath="{.spec.listeners[0].hostname}")" == "api.gateway.local" ]]' \
'Gateway hostname preserved'

check \
'[[ "$(kubectl get gateway api-gateway -o jsonpath="{.spec.listeners[0].tls.certificateRefs[0].name}")" == "api-tls" ]]' \
'TLS Secret preserved'

check \
'kubectl get httproute api-route >/dev/null 2>&1' \
'HTTPRoute exists'

check \
'[[ "$(kubectl get httproute api-route -o jsonpath="{.spec.parentRefs[0].name}")" == "api-gateway" ]]' \
'HTTPRoute attached to Gateway'

check \
'[[ "$(kubectl get httproute api-route -o jsonpath="{.spec.hostnames[0]}")" == "api.gateway.local" ]]' \
'Hostname preserved'

check \
'[[ "$(kubectl get httproute api-route -o jsonpath="{.spec.rules[0].matches[0].path.type}")" == "PathPrefix" ]]' \
'Path type preserved'

check \
'[[ "$(kubectl get httproute api-route -o jsonpath="{.spec.rules[0].matches[0].path.value}")" == "/" ]]' \
'Path preserved'

check \
'[[ "$(kubectl get httproute api-route -o jsonpath="{.spec.rules[0].backendRefs[0].name}")" == "api-service" ]]' \
'Backend Service preserved'

check \
'[[ "$(kubectl get httproute api-route -o jsonpath="{.spec.rules[0].backendRefs[0].port}")" == "80" ]]' \
'Backend Port preserved'

echo

if [ $FAILED -eq 0 ]; then
    echo "========================================"
    echo "✅ Question 10 PASSED"
    echo "========================================"
    exit 0
else
    echo "========================================"
    echo "❌ Question 10 FAILED"
    echo "========================================"
    exit 1
fi