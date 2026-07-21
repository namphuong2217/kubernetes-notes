#!/bin/bash

set -e

echo "Cleaning previous environment..."

kubectl delete namespace eager-fox --ignore-not-found=true >/dev/null 2>&1

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: eager-fox
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: blog-app
  namespace: eager-fox
spec:
  replicas: 5
  selector:
    matchLabels:
      app: blog-app
  template:
    metadata:
      labels:
        app: blog-app
    spec:
      initContainers:
      - name: init-db
        image: busybox:stable
        command:
        - sh
        - -c
        - sleep 2
      containers:
      - name: blog-app
        image: nginx:stable
EOF

kubectl rollout status deployment/blog-app -n eager-fox

echo
echo "========================================"
echo "Question 4 environment is ready."
echo "========================================"