#!/bin/bash

set -e

kubectl delete deployment redis -n redis-store --ignore-not-found=true
kubectl delete pvc redis-data -n redis-store --ignore-not-found=true
kubectl delete -f setup.yaml --ignore-not-found=true

rm -f setup.yaml
rm -f redis-deploy.yaml

echo
echo "Cleanup completed."