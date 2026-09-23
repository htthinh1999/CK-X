#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=capacity; DEP=load-planner
# quantity -> integer milli-units (handles m, k/M/G/T, Ki/Mi/Gi/Ti and plain numbers)
q2m() {
  [ -z "$1" ] || [ "$1" = "null" ] && { echo none; return; }
  echo "$1" | awk '{
    s=$0; n=s; u="";
    if (match(s, /[A-Za-z]+$/)) { n=substr(s,1,RSTART-1); u=substr(s,RSTART) }
    f["m"]=0.001; f[""]=1; f["k"]=1e3; f["M"]=1e6; f["G"]=1e9; f["T"]=1e12;
    f["Ki"]=1024; f["Mi"]=1048576; f["Gi"]=1073741824; f["Ti"]=1099511627776;
    if (!(u in f)) { print "bad"; exit }
    printf "%.0f\n", n * f[u] * 1000
  }'
}

json=$(kubectl -n "$NS" get deployment "$DEP" -o json 2>/dev/null) || { echo "FAIL: Deployment $DEP not found"; exit 1; }
r=$(echo "$json" | jq -c '.spec.template.spec.containers[] | select(.name=="cache") | .resources')
[ -n "$r" ] || { echo "FAIL: container cache not found in $DEP"; exit 1; }

rm_=$(q2m "$(echo "$r" | jq -r '.requests.memory')")
lm_=$(q2m "$(echo "$r" | jq -r '.limits.memory')")
rc_=$(q2m "$(echo "$r" | jq -r '.requests.cpu')")
lc_=$(q2m "$(echo "$r" | jq -r '.limits.cpu')")
[ "$rm_" = "$(q2m 96Mi)" ]  || { echo "FAIL: cache memory request must be 96Mi (got $(echo "$r" | jq -r '.requests.memory'))"; exit 1; }
[ "$lm_" = "$(q2m 128Mi)" ] || { echo "FAIL: cache memory limit must be 128Mi (got $(echo "$r" | jq -r '.limits.memory'))"; exit 1; }
[ "$rc_" = "$(q2m 50m)" ]   || { echo "FAIL: cache cpu request must stay 50m (got $(echo "$r" | jq -r '.requests.cpu'))"; exit 1; }
[ "$lc_" = "$(q2m 100m)" ]  || { echo "FAIL: cache cpu limit must stay 100m (got $(echo "$r" | jq -r '.limits.cpu'))"; exit 1; }
# nothing else may change: the planner container and the decoy Deployment
res() { # deployment container field
  q2m "$(kubectl -n "$NS" get deployment "$1" -o json 2>/dev/null | jq -r --arg c "$2" ".spec.template.spec.containers[] | select(.name==\$c) | .resources.$3 // empty")"
}
want() { [ "$(res "$1" "$2" "$3")" = "$(q2m "$4")" ] || { echo "FAIL: $1/$2 $3 must stay $4 (only the blocking setting may change)"; exit 1; }; }

want load-planner planner requests.cpu 100m
want load-planner planner requests.memory 128Mi
want load-planner planner limits.cpu 250m
want load-planner planner limits.memory 256Mi
want load-reporter report requests.cpu 400
want load-reporter report limits.cpu 400
n=$(kubectl -n "$NS" get deployment load-reporter -o jsonpath='{.spec.replicas}' 2>/dev/null)
[ "$n" = "2" ] || { echo "FAIL: Deployment load-reporter must be left unchanged"; exit 1; }
echo "PASS: only the cache container changed: memory 96Mi/128Mi, cpu 50m/100m; planner and load-reporter unchanged"
exit 0
