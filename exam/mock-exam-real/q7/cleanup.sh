#!/bin/bash

set +e

kubectl delete namespace workloads --ignore-not-found=true

kubectl delete priorityclass high-priority --ignore-not-found=true
kubectl delete priorityclass medium-priority --ignore-not-found=true
kubectl delete priorityclass elevated-priority --ignore-not-found=true

echo
echo "========================================"
echo "Question 7 cleaned."
echo "========================================"