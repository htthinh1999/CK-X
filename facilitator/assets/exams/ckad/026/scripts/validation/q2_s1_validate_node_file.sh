#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
FILE=/home/candidate/exam/q2/depot-node.txt

NODE=$(kubectl get nodes -l '!node-role.kubernetes.io/control-plane' -o jsonpath='{.items[0].metadata.name}' 2>/dev/null)
[ -n "$NODE" ] || NODE=$(kubectl get nodes -o jsonpath='{.items[0].metadata.name}' 2>/dev/null)
[ -n "$NODE" ] || { echo "ERR: cannot determine the depot node"; exit 1; }

[ -f "$FILE" ] || { echo "ERR: $FILE not found"; exit 1; }
got=$(tr -d '\r' < "$FILE" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//; s#^node/##' | sed '/^$/d')

[ "$got" = "$NODE" ] || { echo "ERR: $FILE contains '$got', expected the depot node name"; exit 1; }

echo "OK: $FILE names the depot node $NODE"
exit 0
