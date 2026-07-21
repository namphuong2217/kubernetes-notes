#!/bin/bash

set -e

MANIFEST="/etc/kubernetes/manifests/kube-apiserver.yaml"

echo "========================================"
echo "Chuẩn bị môi trường cho Câu 14..."
echo "========================================"

if [ ! -f "$MANIFEST" ]; then
    echo "❌ Không tìm thấy $MANIFEST"
    exit 1
fi

echo "Đang sao lưu manifest..."

cp "$MANIFEST" "${MANIFEST}.bak"

CURRENT_ENDPOINT=$(grep -oP '(?<=--etcd-servers=https://)[^:]+(?=:2379)' "$MANIFEST" | head -1)

echo "Endpoint etcd hiện tại:"
echo "  $CURRENT_ENDPOINT"

if [ "$CURRENT_ENDPOINT" = "192.168.1.10" ]; then
    echo
    echo "⚠️ Manifest đã trỏ tới endpoint sai."
    echo "Không cần thay đổi."
    exit 0
fi

echo
echo "Đang đổi endpoint etcd sang IP cũ..."

sed -i 's#--etcd-servers=https://192\.168\.1\.20:2379#--etcd-servers=https://192.168.1.10:2379#g' "$MANIFEST"

echo
echo "Manifest đã được cập nhật."
echo
echo "Kubelet sẽ tự phát hiện thay đổi và restart Static Pod kube-apiserver."

echo
echo "Đợi khoảng 30~60 giây..."

sleep 10

echo
echo "========================================"
echo "✅ Môi trường đã sẵn sàng."
echo "========================================"
echo
echo "Lúc này:"
echo
echo "- kube-apiserver sẽ restart liên tục."
echo "- kubectl sẽ không còn hoạt động."
echo "- Học viên cần tự chẩn đoán và sửa lại endpoint etcd."