#!/bin/bash

set +e

kubectl delete deployment apache-web --ignore-not-found=true

rm -f apache-web.yaml

echo
echo "========================================"
echo "Question 3 cleaned."
echo "========================================"