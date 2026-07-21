#!/bin/bash

set -e

echo "========================================"
echo "Chuẩn bị môi trường cho Câu 12..."
echo "========================================"

echo "Đang dọn dẹp môi trường cũ..."

kubectl delete ns web-tier --ignore-not-found >/dev/null 2>&1
kubectl delete ns api-tier --ignore-not-found >/dev/null 2>&1

rm -rf /root/netpols
mkdir -p /root/netpols

echo "Đang tạo namespace..."

kubectl create ns web-tier >/dev/null
kubectl create ns api-tier >/dev/null

echo "Đang tạo Deployment..."

cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-tier
  namespace: web-tier
spec:
  replicas: 1
  selector:
    matchLabels:
      app: web-tier
  template:
    metadata:
      labels:
        app: web-tier
    spec:
      containers:
      - name: curl
        image: curlimages/curl:8.8.0
        command:
        - sleep
        - infinity
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-tier
  namespace: api-tier
spec:
  replicas: 1
  selector:
    matchLabels:
      app: api-tier
  template:
    metadata:
      labels:
        app: api-tier
    spec:
      containers:
      - name: http
        image: hashicorp/http-echo:1.0.0
        args:
        - "-listen=:8080"
        - "-text=api-tier"
        ports:
        - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: api-tier-service
  namespace: api-tier
spec:
  selector:
    app: api-tier
  ports:
  - port: 8080
    targetPort: 8080
EOF

kubectl rollout status deploy/web-tier -n web-tier >/dev/null
kubectl rollout status deploy/api-tier -n api-tier >/dev/null

echo "Đang tạo 3 NetworkPolicy..."

cat >/root/netpols/policy-1.yaml <<'EOF'
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: policy-1
  namespace: api-tier
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  ingress:
  - {}
EOF

cat >/root/netpols/policy-2.yaml <<'EOF'
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: policy-2
  namespace: api-tier
spec:
  podSelector:
    matchLabels:
      app: api-tier
  policyTypes:
  - Ingress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          kubernetes.io/metadata.name: web-tier
    - ipBlock:
        cidr: 10.0.0.0/8
    ports:
    - protocol: TCP
      port: 8080
EOF

cat >/root/netpols/policy-3.yaml <<'EOF'
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: policy-3
  namespace: api-tier
spec:
  podSelector:
    matchLabels:
      app: api-tier
  policyTypes:
  - Ingress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          kubernetes.io/metadata.name: web-tier
      podSelector:
        matchLabels:
          app: web-tier
    ports:
    - protocol: TCP
      port: 8080
EOF

echo
echo "========================================"
echo "✅ Môi trường Câu 12 đã sẵn sàng."
echo "========================================"
echo
echo "Các file cần xem:"
echo
echo "  /root/netpols/policy-1.yaml"
echo "  /root/netpols/policy-2.yaml"
echo "  /root/netpols/policy-3.yaml"
echo