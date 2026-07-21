#!/bin/bash

set +e

echo "========================================"
echo "Dọn dẹp môi trường Câu 13..."
echo "========================================"

kubectl delete storageclass local-fast --ignore-not-found

kubectl delete storageclass standard --ignore-not-found

echo
echo "========================================"
echo "✅ Đã dọn dẹp xong."
echo "========================================"