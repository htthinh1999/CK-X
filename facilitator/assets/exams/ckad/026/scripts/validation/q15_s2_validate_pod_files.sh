#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=fares; DEP=fare-board; C=board

json=$(kubectl -n "$NS" get deployment "$DEP" -o json 2>/dev/null) || { echo "ERR: Deployment $DEP not found"; exit 1; }
img=$(echo "$json" | jq -r --arg c "$C" '[.spec.template.spec.containers[] | select(.name==$c)][0].image')
[ "$img" = "nginx:1.25" ] || { echo "ERR: container $C image changed to '$img'"; exit 1; }
style=$(echo "$json" | jq -r --arg c "$C" '.spec.template.spec as $s | [$s.containers[] | select(.name==$c)][0].volumeMounts[]? | select((.mountPath | sub("/+$"; "")) == "/usr/share/nginx/html/style") | .name as $n | [$s.volumes[] | select(.name==$n)][0].configMap.name // empty')
[ "$style" = "board-style" ] || { echo "ERR: the board-style mount at /usr/share/nginx/html/style is missing"; exit 1; }

rev=$(echo "$json" | jq -r '.metadata.annotations["deployment.kubernetes.io/revision"] // ""')
hash=$(kubectl -n "$NS" get rs -l app=fare-board -o json 2>/dev/null | jq -r --arg r "$rev" '[.items[] | select(.metadata.annotations["deployment.kubernetes.io/revision"] == $r)][0].metadata.labels["pod-template-hash"] // empty')
[ -n "$hash" ] || { echo "ERR: cannot find the current ReplicaSet of $DEP"; exit 1; }
pod=$(kubectl -n "$NS" get pods -l "app=fare-board,pod-template-hash=$hash" --field-selector=status.phase=Running -o json 2>/dev/null \
  | jq -r '[.items[] | select(.metadata.deletionTimestamp == null)][0].metadata.name // empty')
[ -n "$pod" ] || { echo "ERR: no running Pod of the current $DEP template"; exit 1; }

list=$(timeout 15 kubectl -n "$NS" exec "$pod" -c "$C" -- ls -1 /usr/share/nginx/html/fares 2>/dev/null | tr '\n' ' ' | sed 's/ *$//')
[ "$list" = "current.txt offpeak.txt" ] || { echo "ERR: /usr/share/nginx/html/fares in $pod contains '$list', expected only current.txt and offpeak.txt"; exit 1; }
timeout 15 kubectl -n "$NS" exec "$pod" -c "$C" -- test -f /usr/share/nginx/html/index.html >/dev/null 2>&1 \
  || { echo "ERR: /usr/share/nginx/html/index.html is gone in $pod (the html directory is shadowed)"; exit 1; }
want=$(kubectl -n "$NS" get configmap fare-table -o json 2>/dev/null | jq -r '.data["offpeak.txt"] // empty')
got=$(timeout 15 kubectl -n "$NS" exec "$pod" -c "$C" -- cat /usr/share/nginx/html/fares/offpeak.txt 2>/dev/null)
[ -n "$got" ] && [ "$got" = "$(printf '%s' "$want")" ] || { echo "ERR: offpeak.txt in $pod ('$got') does not match fare-table ('$want')"; exit 1; }

echo "OK: $pod serves only current.txt and offpeak.txt from fare-table, index.html intact"
exit 0
