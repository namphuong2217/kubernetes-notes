#!/bin/bash

set -e

MANIFEST="/etc/kubernetes/manifests/kube-apiserver.yaml"
BACKUP="${MANIFEST}.bak"

echo "========================================"
echo "Dọn dẹp môi trường Câu 14..."
echo "========================================"

if [ ! -f "$BACKUP" ]; then
    echo "❌ Không tìm thấy file backup:"
    echo "   $BACKUP"
    echo
    echo "Không thể khôi phục kube-apiserver."
    exit 1
fi

echo "Đang khôi phục kube-apiserver.yaml..."

cp "$BACKUP" "$MANIFEST"

echo
echo "Đã khôi phục manifest."

echo
echo "Kubelet sẽ tự động phát hiện thay đổi"
echo "và khởi động lại kube-apiserver."

echo
echo "Đợi khoảng 60 giây..."

sleep 60

echo
if kubectl get nodes >/dev/null 2>&1; then
    echo "========================================"
    echo "✅ Đã khôi phục môi trường thành công."
    echo "========================================"
else
    echo "========================================"
    echo "⚠️ Manifest đã được khôi phục."
    echo "Nếu API Server vẫn chưa hoạt động,"
    echo "hãy đợi thêm vài giây rồi kiểm tra:"
    echo
    echo "kubectl get nodes"
    echo "crictl ps -a | grep kube-apiserver"
    echo "========================================"
fi