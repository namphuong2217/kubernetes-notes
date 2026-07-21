#!/bin/bash

set +e

echo "========================================"
echo "Dọn dẹp môi trường Câu 10..."
echo "========================================"

kubectl delete gateway api-gateway --ignore-not-found
kubectl delete httproute api-route --ignore-not-found

kubectl delete ingress api-ingress --ignore-not-found
kubectl delete deployment api-service --ignore-not-found
kubectl delete service api-service --ignore-not-found
kubectl delete secret api-tls --ignore-not-found
kubectl delete gatewayclass nginx-gw --ignore-not-found

echo
echo "========================================"
echo "✅ Đã dọn dẹp xong."
echo "========================================"