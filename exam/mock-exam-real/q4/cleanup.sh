#!/bin/bash

set +e

kubectl delete namespace eager-fox --ignore-not-found=true

echo
echo "========================================"
echo "Question 4 cleaned."
echo "========================================"