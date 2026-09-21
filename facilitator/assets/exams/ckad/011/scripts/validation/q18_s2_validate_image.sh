#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
image=$(kubectl get job pi-job -n coral -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
case "$image" in
  *perl*) echo "Success: image is perl ($image)"; exit 0 ;;
  *) echo "Error: image is '$image', expected perl"; exit 1 ;;
esac
