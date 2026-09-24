#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
sel=$(kubectl get deploy broken-app -n default -o jsonpath='{.spec.selector.matchLabels.app}' 2>/dev/null)
tpl=$(kubectl get deploy broken-app -n default -o jsonpath='{.spec.template.metadata.labels.app}' 2>/dev/null)
if [ -n "$sel" ] && [ "$sel" = "$tpl" ]; then echo "Success: selector matches template labels"; exit 0; else echo "Error: selector '$sel' != template '$tpl'"; exit 1; fi
