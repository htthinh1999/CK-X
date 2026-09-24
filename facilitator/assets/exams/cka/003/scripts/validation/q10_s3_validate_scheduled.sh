#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
node=$(kubectl $CTX -n alpha get pod pinned -o jsonpath='{.spec.nodeName}' 2>/dev/null)
[ -z "$node" ] && { echo "ERR: pod pinned not scheduled"; exit 1; }
lbl=$(kubectl $CTX get node "$node" -o jsonpath='{.metadata.labels.disk}' 2>/dev/null)
[ "$lbl" = "ssd" ] && { echo "OK: scheduled on $node (disk=ssd)"; exit 0; }
echo "ERR: pod on node $node without disk=ssd label"; exit 1
