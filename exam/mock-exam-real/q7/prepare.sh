#!/bin/bash

set -e

echo "Cleaning previous environment..."

kubectl delete namespace workloads --ignore-not-found=true >/dev/null 2>&1
kubectl delete priorityclass high-priority --ignore-not-found=true >/dev/null 2>&1
kubectl delete priorityclass medium-priority --ignore-not-found=true >/dev/null 2>&1
kubectl delete priorityclass elevated-priority --ignore-not-found=true >/dev/null 2>&1

cat <<EOF | kubectl apply -f -
apiVersion: scheduling.k8s.io/v1
kind: PriorityClass
metadata:
  name: medium-priority
value: 500000
globalDefault: false
description: Medium priority
---
apiVersion: scheduling.k8s.io/v1
kind: PriorityClass
metadata:
  name: high-priority
value: 900000
globalDefault: false
description: High priority
---
apiVersion: v1
kind: Namespace
metadata:
  name: workloads
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: log-collector
  namespace: workloads
spec:
  replicas: 1
  selector:
    matchLabels:
      app: log-collector
  template:
    metadata:
      labels:
        app: log-collector
    spec:
      containers:
      - name: log-collector
        image: busybox:stable
        command:
        - sh
        - -c
        - sleep 3600
EOF

kubectl rollout status deployment/log-collector -n workloads

echo
echo "========================================"
echo "Question 7 environment is ready."
echo "========================================"