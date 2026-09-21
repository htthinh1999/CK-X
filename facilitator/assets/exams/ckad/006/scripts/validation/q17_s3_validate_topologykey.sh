#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get pod spread-pod -n eddy -o jsonpath='{.spec.topologySpreadConstraints[0].topologyKey}' 2>/dev/null)
if [ "$v" = "kubernetes.io/hostname" ]; then echo "Success: topologyKey is kubernetes.io/hostname"; exit 0; else echo "Error: topologyKey is '$v', expected kubernetes.io/hostname"; exit 1; fi
