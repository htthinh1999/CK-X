#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=mirror
D=reflector
WANT="bump reflector to nginx 1.26"

cc=$(kubectl -n "$NS" get deployment "$D" -o json 2>/dev/null | jq -r '.metadata.annotations["kubernetes.io/change-cause"] // empty' 2>/dev/null | sed 's/[[:space:]]*$//')
[ "$cc" = "$WANT" ] && { echo "OK: change-cause is '$cc'"; exit 0; }
echo "ERR: change-cause is '${cc:-<missing>}', expected '$WANT'"
exit 1
