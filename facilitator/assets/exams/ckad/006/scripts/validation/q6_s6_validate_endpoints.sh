#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
c=$(kubectl get endpoints web-service -n default -o jsonpath='{.subsets[0].addresses}' 2>/dev/null | grep -o "ip" | wc -l)
if [ "$c" -ge 5 ]; then echo "Success: web-service has $c endpoints (>=5)"; exit 0; else echo "Error: web-service has $c endpoints, expected >=5"; exit 1; fi
