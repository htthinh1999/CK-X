#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=routes; DEP=prod-route-board

json=$(kubectl -n "$NS" get deployment "$DEP" -o json 2>/dev/null) || { echo "FAIL: Deployment $DEP not found in $NS"; exit 1; }

sel=$(echo "$json" | jq -c '.spec.selector.matchLabels // {} | to_entries | sort_by(.key) | from_entries')
[ "$sel" = '{"app":"route-board","env":"prod"}' ] || { echo "FAIL: $DEP selector must be app=route-board,env=prod (got $sel)"; exit 1; }

spec=$(echo "$json" | jq -r '.spec.replicas')
[ "$spec" = "3" ] || { echo "FAIL: $DEP must run 3 replicas (got $spec)"; exit 1; }

web=$(echo "$json" | jq -r '.spec.template.spec.containers[] | select(.name=="web") | .image')
side=$(echo "$json" | jq -r '.spec.template.spec.containers[] | select(.name=="feed-sync") | .image')
[ "$web" = "nginx:1.26" ] || { echo "FAIL: container web must use nginx:1.26 (got '$web')"; exit 1; }
[ "$side" = "busybox:1.36" ] || { echo "FAIL: container feed-sync must keep busybox:1.36 (got '$side')"; exit 1; }

gen=$(echo "$json" | jq -r '.metadata.generation'); obs=$(echo "$json" | jq -r '.status.observedGeneration // 0')
upd=$(echo "$json" | jq -r '.status.updatedReplicas // 0'); rdy=$(echo "$json" | jq -r '.status.readyReplicas // 0')
if [ "$obs" -lt "$gen" ] || [ "$upd" != "3" ] || [ "$rdy" != "3" ]; then
  echo "FAIL: $DEP is not fully rolled out (updated=$upd ready=$rdy)"
  exit 1
fi
echo "PASS: $DEP runs 3 Ready replicas with web on nginx:1.26 and env=prod in its selector"
exit 0
