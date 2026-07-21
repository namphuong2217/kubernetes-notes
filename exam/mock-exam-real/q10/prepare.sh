#!/bin/bash

set -e

echo "========================================"
echo "Chuẩn bị môi trường cho Câu 10..."
echo "========================================"

echo "Đang dọn dẹp môi trường cũ..."

kubectl delete gateway api-gateway --ignore-not-found >/dev/null 2>&1
kubectl delete httproute api-route --ignore-not-found >/dev/null 2>&1
kubectl delete ingress api-ingress --ignore-not-found >/dev/null 2>&1
kubectl delete deployment api-service --ignore-not-found >/dev/null 2>&1
kubectl delete service api-service --ignore-not-found >/dev/null 2>&1
kubectl delete secret api-tls --ignore-not-found >/dev/null 2>&1
kubectl delete gatewayclass nginx-gw --ignore-not-found >/dev/null 2>&1

echo "Đang tạo GatewayClass..."

cat <<EOF | kubectl apply -f -
apiVersion: gateway.networking.k8s.io/v1
kind: GatewayClass
metadata:
  name: nginx-gw
spec:
  controllerName: example.com/gateway-controller
EOF

echo "Đang tạo TLS Secret..."

openssl req \
-x509 \
-nodes \
-newkey rsa:2048 \
-days 365 \
-keyout tls.key \
-out tls.crt \
-subj "/CN=api.gateway.local" >/dev/null 2>&1

kubectl create secret tls api-tls \
--cert=tls.crt \
--key=tls.key >/dev/null

rm -f tls.crt tls.key

echo "Đang tạo Deployment và Service..."

cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-service
spec:
  replicas: 1
  selector:
    matchLabels:
      app: api
  template:
    metadata:
      labels:
        app: api
    spec:
      containers:
      - name: nginx
        image: nginx:stable
---
apiVersion: v1
kind: Service
metadata:
  name: api-service
spec:
  selector:
    app: api
  ports:
  - port: 80
    targetPort: 80
EOF

kubectl rollout status deployment/api-service >/dev/null

echo "Đang tạo Ingress..."

cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: api-ingress
spec:
  tls:
  - hosts:
    - api.gateway.local
    secretName: api-tls
  rules:
  - host: api.gateway.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: api-service
            port:
              number: 80
EOF

echo
echo "========================================"
echo "✅ Môi trường Câu 10 đã sẵn sàng."
echo "========================================"
echo
echo "Ingress cần migrate:"
echo "  Name     : api-ingress"
echo "  Host     : api.gateway.local"
echo "  TLS      : api-tls"
echo "  Backend  : api-service:80"
echo