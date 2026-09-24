#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=yardsafety; DEP=shunter

json=$(kubectl -n "$NS" get deployment "$DEP" -o json 2>/dev/null) || { echo "ERR: Deployment $DEP not found"; exit 1; }
spec=$(echo "$json" | jq -c '.spec.template.spec')

echo "$spec" | jq -e '[.volumes[]? | select(.hostPath)] | length == 0' >/dev/null || { echo "ERR: the Pod template still uses a hostPath volume"; exit 1; }
echo "$spec" | jq -e '[.volumes[]? | select(.name == "scratch" and .emptyDir != null)] | length == 1' >/dev/null || { echo "ERR: volume scratch must be an emptyDir"; exit 1; }
for c in prep shunter; do
  echo "$spec" | jq -e --arg c "$c" '[(.initContainers // [])[], .containers[]] | [.[] | select(.name == $c)][0].volumeMounts // [] | map(select(.name == "scratch" and (.mountPath | sub("/+$"; "")) == "/scratch")) | length == 1' >/dev/null \
    || { echo "ERR: container $c does not mount scratch at /scratch"; exit 1; }
done

got=$(echo "$spec" | jq -c '[(.initContainers // [])[], .containers[]] | map({name, image, command, args}) | sort_by(.name)')
want='[{"name":"prep","image":"busybox:1.36","command":["sh","-c","echo '"'"'plan: siding-4 -> platform-2'"'"' > /scratch/plan.txt"],"args":null},{"name":"shunter","image":"busybox:1.36","command":["sh","-c","cat /scratch/plan.txt; while true; do date >> /scratch/moves.log; sleep 30; done"],"args":null}]'
[ "$got" = "$(echo "$want" | jq -c .)" ] || { echo "ERR: images or commands of $DEP were changed"; exit 1; }

echo "OK: scratch is an emptyDir mounted at /scratch; images and commands unchanged"
exit 0
