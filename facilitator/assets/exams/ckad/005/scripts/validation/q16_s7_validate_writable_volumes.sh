#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
cache=$(kubectl get pod hardened-pod -n predator -o jsonpath='{.spec.containers[0].volumeMounts[?(@.mountPath=="/var/cache/nginx")].name}' 2>/dev/null)
run=$(kubectl get pod hardened-pod -n predator -o jsonpath='{.spec.containers[0].volumeMounts[?(@.mountPath=="/var/run")].name}' 2>/dev/null)
c=0
[ -n "$cache" ] && c=$((c+1))
[ -n "$run" ] && c=$((c+1))
if [ "$c" -ge 2 ]; then echo "Success: writable volumes present ($c)"; exit 0; else echo "Error: only $c writable volumes, expected >=2"; exit 1; fi
