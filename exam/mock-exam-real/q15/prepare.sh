#!/bin/bash

set -e

echo "========================================"
echo "Chuẩn bị môi trường cho Câu 15..."
echo "========================================"

kubectl delete service web-front-svc -n svc-lab --ignore-not-found >/dev/null 2>&1
kubectl delete deployment web-front -n svc-lab --ignore-not-found >/dev/null 2>&1

kubectl delete namespace svc-lab --ignore-not-found >/dev/null 2>&1

while kubectl get namespace svc-lab >/dev/null 2>&1; do
    sleep 1
done

kubectl create namespace svc-lab

cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-front
  namespace: svc-lab
spec:
  replicas: 1
  selector:
    matchLabels:
      app: web-front
  template:
    metadata:
      labels:
        app: web-front
    spec:
      containers:
      - name: node-app
        image: nginx:stable
EOF

kubectl rollout status deployment/web-front -n svc-lab --timeout=120s

echo
echo "========================================"
echo "Đã chuẩn bị xong môi trường."
echo "========================================"