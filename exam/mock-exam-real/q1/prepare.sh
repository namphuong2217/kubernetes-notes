#!/bin/bash

set -e

cat <<'EOF' > setup.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: redis-store
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: redis-pv
spec:
  capacity:
    storage: 500Mi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: ""
  hostPath:
    path: /opt/redis-data
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: redis-old
  namespace: redis-store
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: ""
  resources:
    requests:
      storage: 500Mi
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis
  namespace: redis-store
spec:
  replicas: 1
  selector:
    matchLabels:
      app: redis
  template:
    metadata:
      labels:
        app: redis
    spec:
      containers:
        - name: redis
          image: redis:7.2
          volumeMounts:
            - name: redis-data
              mountPath: /data
      volumes:
        - name: redis-data
          persistentVolumeClaim:
            claimName: redis-old
EOF

cat <<'EOF' > redis-deploy.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis
  namespace: redis-store
spec:
  replicas: 1
  selector:
    matchLabels:
      app: redis
  template:
    metadata:
      labels:
        app: redis
    spec:
      containers:
        - name: redis
          image: redis:7.2
          volumeMounts:
            - name: redis-data
              mountPath: /data
      volumes:
        - name: redis-data
          persistentVolumeClaim:
            claimName: CHANGE_ME
EOF

kubectl apply -f setup.yaml

kubectl rollout status deployment/redis -n redis-store

kubectl delete deployment redis -n redis-store

kubectl delete pvc redis-old -n redis-store

echo
echo "========================================"
echo "Question 1 is ready."
echo "Please read question.md and start."
echo "========================================"