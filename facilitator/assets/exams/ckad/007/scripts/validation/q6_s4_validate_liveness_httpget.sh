#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get pod slow-starter -n wave -o jsonpath='{.spec.containers[0].livenessProbe}' 2>/dev/null | grep -q "httpGet"; then echo "Success: livenessProbe httpGet"; exit 0; else echo "Error: livenessProbe httpGet - not found"; exit 1; fi
