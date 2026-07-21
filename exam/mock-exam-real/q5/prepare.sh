#!/bin/bash

set -e

echo "Cleaning previous environment..."

kubectl delete namespace scaling-lab --ignore-not-found=true >/dev/null 2>&1

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: scaling-lab
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-api-deployment
  namespace: scaling-lab
spec:
  replicas: 2
  selector:
    matchLabels:
      app: web-api
  template:
    metadata:
      labels:
        app: web-api
    spec:
      containers:
      - name: web-api
        image: nginx:stable
        resources:
          requests:
            cpu: 100m
EOF

kubectl rollout status deployment/web-api-deployment -n scaling-lab

echo
echo "========================================"
echo "Question 5 environment is ready."
echo "========================================"