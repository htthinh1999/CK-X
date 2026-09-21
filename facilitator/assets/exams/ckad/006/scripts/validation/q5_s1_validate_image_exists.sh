#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if docker images my-app:1.0 --format '{{.Repository}}:{{.Tag}}' 2>/dev/null | grep -q "my-app:1.0"; then echo "Success: image my-app:1.0 exists"; exit 0; else echo "Error: image my-app:1.0 not found"; exit 1; fi
