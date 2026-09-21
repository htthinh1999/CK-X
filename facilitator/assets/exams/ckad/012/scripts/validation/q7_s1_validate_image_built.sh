#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
img=$(docker images -q "localhost:5000/oni-app:1.0" 2>/dev/null)
if [ -n "$img" ]; then echo "Success: image localhost:5000/oni-app:1.0 built"; exit 0
else echo "Error: image localhost:5000/oni-app:1.0 not found"; exit 1; fi
