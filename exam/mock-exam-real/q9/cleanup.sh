#!/bin/bash

set +e

sudo systemctl disable --now containerd >/dev/null 2>&1 || true

sudo rm -f /etc/sysctl.d/k8s.conf

sudo sysctl -w net.bridge.bridge-nf-call-iptables=0 >/dev/null 2>&1 || true
sudo sysctl -w net.bridge.bridge-nf-call-ip6tables=0 >/dev/null 2>&1 || true
sudo sysctl -w net.ipv4.ip_forward=0 >/dev/null 2>&1 || true
sudo sysctl -w net.netfilter.nf_conntrack_max=65536 >/dev/null 2>&1 || true

echo
echo "========================================"
echo "Question 9 cleaned."
echo "========================================"