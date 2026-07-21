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
echo "Verifying Question 4..."
echo "========================================"

check \
'kubectl get deploy blog-app -n eager-fox >/dev/null 2>&1' \
'Deployment exists'

check \
'[[ $(kubectl get deploy blog-app -n eager-fox -o jsonpath="{.spec.replicas}") -eq 5 ]]' \
'Deployment scaled back to 5 replicas'

INIT_REQ_CPU=$(kubectl get deploy blog-app -n eager-fox -o jsonpath='{.spec.template.spec.initContainers[0].resources.requests.cpu}')
MAIN_REQ_CPU=$(kubectl get deploy blog-app -n eager-fox -o jsonpath='{.spec.template.spec.containers[0].resources.requests.cpu}')

INIT_REQ_MEM=$(kubectl get deploy blog-app -n eager-fox -o jsonpath='{.spec.template.spec.initContainers[0].resources.requests.memory}')
MAIN_REQ_MEM=$(kubectl get deploy blog-app -n eager-fox -o jsonpath='{.spec.template.spec.containers[0].resources.requests.memory}')

INIT_LIMIT_CPU=$(kubectl get deploy blog-app -n eager-fox -o jsonpath='{.spec.template.spec.initContainers[0].resources.limits.cpu}')
MAIN_LIMIT_CPU=$(kubectl get deploy blog-app -n eager-fox -o jsonpath='{.spec.template.spec.containers[0].resources.limits.cpu}')

INIT_LIMIT_MEM=$(kubectl get deploy blog-app -n eager-fox -o jsonpath='{.spec.template.spec.initContainers[0].resources.limits.memory}')
MAIN_LIMIT_MEM=$(kubectl get deploy blog-app -n eager-fox -o jsonpath='{.spec.template.spec.containers[0].resources.limits.memory}')

check \
'[[ -n "'"$MAIN_REQ_CPU"'" ]]' \
'CPU request configured'

check \
'[[ -n "'"$MAIN_REQ_MEM"'" ]]' \
'Memory request configured'

check \
'[[ -n "'"$MAIN_LIMIT_CPU"'" ]]' \
'CPU limit configured'

check \
'[[ -n "'"$MAIN_LIMIT_MEM"'" ]]' \
'Memory limit configured'

check \
'[[ "'"$INIT_REQ_CPU"'" == "'"$MAIN_REQ_CPU"'" ]]' \
'Init container CPU request matches main container'

check \
'[[ "'"$INIT_REQ_MEM"'" == "'"$MAIN_REQ_MEM"'" ]]' \
'Init container memory request matches main container'

check \
'[[ "'"$INIT_LIMIT_CPU"'" == "'"$MAIN_LIMIT_CPU"'" ]]' \
'Init container CPU limit matches main container'

check \
'[[ "'"$INIT_LIMIT_MEM"'" == "'"$MAIN_LIMIT_MEM"'" ]]' \
'Init container memory limit matches main container'

check \
'kubectl rollout status deployment/blog-app -n eager-fox >/dev/null 2>&1' \
'Deployment rollout completed'

check \
'[[ $(kubectl get pods -n eager-fox -l app=blog-app --no-headers | grep Running | wc -l) -eq 5 ]]' \
'Five pods are running'

echo

if [ $FAILED -eq 0 ]; then
    echo "========================================"
    echo "✅ Question 4 PASSED"
    echo "========================================"
    exit 0
else
    echo "========================================"
    echo "❌ Question 4 FAILED"
    echo "========================================"
    exit 1
fi
```

Tiếp theo sẽ là **`question.md`** và **`solution.yaml`**.