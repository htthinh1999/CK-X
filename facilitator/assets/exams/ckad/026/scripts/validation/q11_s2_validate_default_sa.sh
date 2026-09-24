#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=permits

names=$(kubectl -n "$NS" get serviceaccount default -o json 2>/dev/null | jq -r '[.imagePullSecrets[]?.name] | sort | join(",")') || { echo "FAIL: ServiceAccount default not found"; exit 1; }
case ",$names," in *,permits-registry,*) ;; *) echo "FAIL: ServiceAccount default does not list permits-registry in imagePullSecrets (got '$names')"; exit 1;; esac
case ",$names," in *,legacy-pull,*) ;; *) echo "FAIL: the existing pull secret legacy-pull was removed from ServiceAccount default (got '$names')"; exit 1;; esac
echo "PASS: ServiceAccount default lists legacy-pull and permits-registry"
exit 0
