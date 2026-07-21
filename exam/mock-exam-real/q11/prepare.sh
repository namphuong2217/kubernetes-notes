#!/bin/bash

set -e

echo "========================================"
echo "Chuẩn bị môi trường cho Câu 11..."
echo "========================================"

echo "Đang dọn dẹp tài nguyên cũ..."

kubectl delete ingress echo-ing -n echo-lab --ignore-not-found >/dev/null 2>&1
kubectl delete svc echo-svc -n echo-lab --ignore-not-found >/dev/null 2>&1
kubectl delete deploy echo-server -n echo-lab --ignore-not-found >/dev/null 2>&1
kubectl delete ns echo-lab --ignore-not-found >/dev/null 2>&1

echo "Đang tạo namespace..."

kubectl create ns echo-lab >/dev/null

echo "Đang tạo Deployment..."

cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: echo-server
  namespace: echo-lab
spec:
  replicas: 1
  selector:
    matchLabels:
      app: echo-server
  template:
    metadata:
      labels:
        app: echo-server
    spec:
      containers:
      - name: echo-server
        image: hashicorp/http-echo:1.0.0
        args:
        - "-text=echo-server"
        - "-listen=:9090"
        ports:
        - containerPort: 9090
EOF

kubectl rollout status deployment/echo-server -n echo-lab >/dev/null

echo
echo "========================================"
echo "✅ Môi trường Câu 11 đã sẵn sàng."
echo "========================================"
echo
echo "Deployment:"
echo "  echo-server"
echo
echo "Namespace:"
echo "  echo-lab"
echo