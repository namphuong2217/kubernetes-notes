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
echo "Verifying Question 5..."
echo "========================================"

check \
'kubectl get hpa web-api -n scaling-lab >/dev/null 2>&1' \
'HPA exists'

check \
'[[ "$(kubectl get hpa web-api -n scaling-lab -o jsonpath="{.spec.scaleTargetRef.kind}")" == "Deployment" ]]' \
'Target kind is Deployment'

check \
'[[ "$(kubectl get hpa web-api -n scaling-lab -o jsonpath="{.spec.scaleTargetRef.name}")" == "web-api-deployment" ]]' \
'Target deployment is correct'

check \
'[[ "$(kubectl get hpa web-api -n scaling-lab -o jsonpath="{.spec.minReplicas}")" == "2" ]]' \
'Minimum replicas is 2'

check \
'[[ "$(kubectl get hpa web-api -n scaling-lab -o jsonpath="{.spec.maxReplicas}")" == "5" ]]' \
'Maximum replicas is 5'

check \
'[[ "$(kubectl get hpa web-api -n scaling-lab -o jsonpath="{.spec.metrics[0].resource.target.averageUtilization}")" == "60" ]]' \
'Target CPU utilization is 60%'

check \
'[[ "$(kubectl get hpa web-api -n scaling-lab -o jsonpath="{.spec.behavior.scaleDown.stabilizationWindowSeconds}")" == "45" ]]' \
'Downscale stabilization window is 45 seconds'

echo

if [ $FAILED -eq 0 ]; then
    echo "========================================"
    echo "✅ Question 5 PASSED"
    echo "========================================"
    exit 0
else
    echo "========================================"
    echo "❌ Question 5 FAILED"
    echo "========================================"
    exit 1
fi
```

---

## `question.md`

````markdown
# Question 5 — Horizontal Pod Autoscaler with Stabilization Window

## Background

An existing Deployment named **web-api-deployment** is running in the **scaling-lab** namespace.

Your task is to create a HorizontalPodAutoscaler for this Deployment.

---

## Tasks

1. Create a HorizontalPodAutoscaler named:

   ```
   web-api
   ```

2. Target the existing Deployment:

   ```
   web-api-deployment
   ```

3. Configure the HPA to maintain:

   ```
   60% average CPU utilization
   ```

4. Configure:

   - Minimum replicas:

     ```
     2
     ```

   - Maximum replicas:

     ```
     5
     ```

5. Configure the downscale stabilization window to:

   ```
   45 seconds
   ```

---

## Validation

After completing the task, verify your solution:

```bash
./verify.sh
```