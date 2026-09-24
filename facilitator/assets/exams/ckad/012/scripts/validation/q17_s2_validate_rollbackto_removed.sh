#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
f="/tmp/exam/course/17/broken-deploy.yaml"
if [ ! -s "$f" ]; then echo "Error: $f not found"; exit 1; fi
if grep -q "rollbackTo" "$f" 2>/dev/null; then echo "Error: deprecated rollbackTo field still present"; exit 1
else echo "Success: deprecated rollbackTo field removed"; exit 0; fi
