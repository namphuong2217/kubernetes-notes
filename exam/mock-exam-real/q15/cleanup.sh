#!/bin/bash

echo "========================================"
echo "Dọn dẹp môi trường..."
echo "========================================"

kubectl delete service web-front-svc -n svc-lab --ignore-not-found >/dev/null 2>&1
kubectl delete deployment web-front -n svc-lab --ignore-not-found >/dev/null 2>&1
kubectl delete namespace svc-lab --ignore-not-found >/dev/null 2>&1

echo
echo "Hoàn tất."