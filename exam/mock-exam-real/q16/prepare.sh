#!/bin/bash

set -e

echo "========================================"
echo "Chuẩn bị môi trường cho Câu 16..."
echo "========================================"

kubectl delete namespace secure-web --ignore-not-found >/dev/null 2>&1

while kubectl get namespace secure-web >/dev/null 2>&1; do
    sleep 1
done

kubectl create namespace secure-web

TMP_DIR=$(mktemp -d)

#############################################
# Generate self-signed certificate
#############################################

openssl req \
    -x509 \
    -nodes \
    -newkey rsa:2048 \
    -days 365 \
    -keyout ${TMP_DIR}/tls.key \
    -out ${TMP_DIR}/tls.crt \
    -subj "/CN=tls-check.k8s.local" >/dev/null 2>&1

kubectl create secret tls web-tls-secret \
    --cert=${TMP_DIR}/tls.crt \
    --key=${TMP_DIR}/tls.key \
    -n secure-web

#############################################
# ConfigMap
#############################################

cat <<'EOF' >/tmp/default.conf
server {

    listen 443 ssl;

    server_name localhost;

    ssl_certificate     /etc/nginx/tls/tls.crt;
    ssl_certificate_key /etc/nginx/tls/tls.key;

    ssl_protocols TLSv1.2 TLSv1.3;

    location / {
        return 200 "TLS OK\n";
    }
}
EOF

kubectl create configmap web-tls-cfg \
    --from-file=default.conf=/tmp/default.conf \
    -n secure-web

#############################################
# Deployment
#############################################

cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: secure-web
  namespace: secure-web
spec:
  replicas: 1
  selector:
    matchLabels:
      app: secure-web
  template:
    metadata:
      labels:
        app: secure-web
    spec:
      containers:
      - name: nginx
        image: nginx:stable

        ports:
        - containerPort: 443

        volumeMounts:

        - name: config
          mountPath: /etc/nginx/conf.d/default.conf
          subPath: default.conf

        - name: tls
          mountPath: /etc/nginx/tls

      volumes:

      - name: config
        configMap:
          name: web-tls-cfg

      - name: tls
        secret:
          secretName: web-tls-secret
EOF

#############################################
# Service
#############################################

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: secure-web
  namespace: secure-web
spec:
  selector:
    app: secure-web
  ports:
  - port: 443
    targetPort: 443
EOF

kubectl rollout status deployment secure-web \
    -n secure-web \
    --timeout=180s

echo
echo "========================================"
echo "Đã chuẩn bị xong môi trường."
echo "========================================"