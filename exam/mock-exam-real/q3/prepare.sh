#!/bin/bash

set -e

echo "Cleaning previous environment..."

kubectl delete deployment apache-web --ignore-not-found=true >/dev/null 2>&1

rm -f apache-web.yaml

cat <<'EOF' > apache-web.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: apache-web
spec:
  replicas: 1
  selector:
    matchLabels:
      app: apache-web
  template:
    metadata:
      labels:
        app: apache-web
    spec:
      containers:
      - name: apache-web
        image: busybox:stable
        command:
        - /bin/sh
        - -c
        - |
          while true; do
            date >> /var/log/apache-web.log
            sleep 2
          done
EOF

kubectl apply -f apache-web.yaml

kubectl rollout status deployment/apache-web

echo
echo "========================================"
echo "Question 3 environment is ready."
echo "========================================"
echo
echo "Edit:"
echo "  apache-web.yaml"
echo