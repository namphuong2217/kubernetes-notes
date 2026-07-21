#!/bin/bash

set +e

echo "========================================"
echo "Dọn dẹp môi trường Câu 11..."
echo "========================================"

kubectl delete ingress echo-ing -n echo-lab --ignore-not-found

kubectl delete svc echo-svc -n echo-lab --ignore-not-found

kubectl delete deploy echo-server -n echo-lab --ignore-not-found

kubectl delete ns echo-lab --ignore-not-found

echo
echo "========================================"
echo "✅ Đã dọn dẹp xong."
echo "========================================"