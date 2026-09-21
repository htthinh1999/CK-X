#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
c=$(kubectl rollout history deploy app-v1 -n brook 2>/dev/null | grep -c "^[0-9]")
if [ "$c" -ge 2 ]; then echo "Success: deployment has $c revisions (>=2)"; exit 0; else echo "Error: deployment has $c revisions, expected >=2"; exit 1; fi
