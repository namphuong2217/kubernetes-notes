#!/bin/bash

set -e

echo "========================================"
echo "Chuẩn bị môi trường cho Câu 13..."
echo "========================================"

echo "Đang dọn dẹp StorageClass cũ..."

kubectl delete storageclass local-fast --ignore-not-found >/dev/null 2>&1

echo "Đang tạo StorageClass mặc định..."

cat <<EOF | kubectl apply -f -
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: standard
  annotations:
    storageclass.kubernetes.io/is-default-class: "true"
provisioner: kubernetes.io/no-provisioner
volumeBindingMode: Immediate
EOF

echo
echo "========================================"
echo "✅ Môi trường Câu 13 đã sẵn sàng."
echo "========================================"
echo
echo "StorageClass hiện tại:"
kubectl get storageclass