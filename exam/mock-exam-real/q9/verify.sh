#!/bin/bash

set +e

FAILED=0

check() {
    if eval "$1"; then
        echo "✅ $2"
    else
        echo "❌ $2"
        FAILED=1
    fi
}

echo "========================================"
echo "Verifying Question 9..."
echo "========================================"

check \
'dpkg -s runc >/dev/null 2>&1' \
'runc package installed'

check \
'systemctl is-enabled containerd | grep -q enabled' \
'containerd is enabled'

check \
'systemctl is-active containerd | grep -q active' \
'containerd is running'

check \
'[[ "$(sysctl -n net.bridge.bridge-nf-call-iptables)" == "1" ]]' \
'net.bridge.bridge-nf-call-iptables = 1'

check \
'[[ "$(sysctl -n net.bridge.bridge-nf-call-ip6tables)" == "1" ]]' \
'net.bridge.bridge-nf-call-ip6tables = 1'

check \
'[[ "$(sysctl -n net.ipv4.ip_forward)" == "1" ]]' \
'net.ipv4.ip_forward = 1'

check \
'[[ "$(sysctl -n net.netfilter.nf_conntrack_max)" == "262144" ]]' \
'nf_conntrack_max = 262144'

check \
'grep -q "net.bridge.bridge-nf-call-iptables=1" /etc/sysctl.d/k8s.conf' \
'Persistent sysctl configuration exists'

echo

if [ $FAILED -eq 0 ]; then
    echo "========================================"
    echo "✅ Question 9 PASSED"
    echo "========================================"
    exit 0
else
    echo "========================================"
    echo "❌ Question 9 FAILED"
    echo "========================================"
    exit 1
fi