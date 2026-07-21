#!/bin/bash

set +e

echo "========================================"
echo "Dọn dẹp môi trường Câu 12..."
echo "========================================"

kubectl delete ns web-tier --ignore-not-found

kubectl delete ns api-tier --ignore-not-found

rm -rf /root/netpols

echo
echo "========================================"
echo "✅ Đã dọn dẹp xong."
echo "========================================"