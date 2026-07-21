#!/bin/bash

echo "========================================"
echo "Dọn dẹp môi trường..."
echo "========================================"

kubectl delete namespace secure-web \
    --ignore-not-found >/dev/null 2>&1

while kubectl get namespace secure-web >/dev/null 2>&1; do
    sleep 1
done

grep -v "tls-check.k8s.local" /etc/hosts >/tmp/hosts.clean

cat /tmp/hosts.clean >/etc/hosts

rm -f /tmp/default.conf
rm -f /tmp/hosts.clean

echo
echo "========================================"
echo "Hoàn tất."
echo "========================================"