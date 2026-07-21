#!/bin/bash

set +e

kubectl delete namespace scaling-lab --ignore-not-found=true

rm -f hpa.yaml

echo
echo "========================================"
echo "Question 5 cleaned."
echo "========================================"