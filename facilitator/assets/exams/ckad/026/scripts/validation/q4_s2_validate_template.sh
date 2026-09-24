#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=depot
DEP=wagon-sorter

NODE=$(kubectl get nodes -l '!node-role.kubernetes.io/control-plane' -o jsonpath='{.items[0].metadata.name}' 2>/dev/null)
[ -n "$NODE" ] || NODE=$(kubectl get nodes -o jsonpath='{.items[0].metadata.name}' 2>/dev/null)
[ -n "$NODE" ] || { echo "ERR: cannot determine the depot node"; exit 1; }

spec=$(kubectl -n "$NS" get deployment "$DEP" -o json 2>/dev/null | jq -c '.spec.template.spec') \
  || { echo "ERR: Deployment $DEP not found in $NS"; exit 1; }
[ -n "$spec" ] && [ "$spec" != "null" ] || { echo "ERR: Deployment $DEP not found in $NS"; exit 1; }

nn=$(echo "$spec" | jq -r '.nodeName // empty')
[ -z "$nn" ] || { echo "ERR: pod template sets nodeName ($nn); scheduling must be done by the scheduler"; exit 1; }

# The template must tolerate the depot taint dedicated=depot:NoSchedule
tol=$(echo "$spec" | jq -r '
  [ (.tolerations // [])[]
    | select( ((.key // "") == "dedicated") or (((.key // "") == "") and .operator == "Exists") )
    | select( ((.effect // "") == "") or (.effect == "NoSchedule") )
    | select( (.operator == "Exists") or ((.value // "") == "depot") )
  ] | length')
[ "${tol:-0}" -ge 1 ] 2>/dev/null || { echo "ERR: pod template does not tolerate the taint dedicated=depot:NoSchedule"; exit 1; }

# Evaluate nodeSelector + required node affinity against every node
nodes=$(kubectl get nodes -o json 2>/dev/null) || { echo "ERR: cannot list nodes"; exit 1; }
matching=$(jq -rn --argjson spec "$spec" --argjson nodes "$nodes" '
  def req_match($lbl):
    . as $e | ($lbl[$e.key]) as $v | ($e.values // []) as $vals
    | if   $e.operator == "In"           then ($v != null and ($vals | any(. == $v)))
      elif $e.operator == "NotIn"        then ($v == null or ($vals | all(. != $v)))
      elif $e.operator == "Exists"       then $v != null
      elif $e.operator == "DoesNotExist" then $v == null
      elif $e.operator == "Gt"           then ($v != null and (($v|tonumber? // null) != null) and (($v|tonumber) > ($vals[0]|tonumber)))
      elif $e.operator == "Lt"           then ($v != null and (($v|tonumber? // null) != null) and (($v|tonumber) < ($vals[0]|tonumber)))
      else false end;
  def term_match($lbl; $fld):
    ((.matchExpressions // []) as $me | (.matchFields // []) as $mf
     | (($me | length) + ($mf | length)) > 0
       and ($me | all(req_match($lbl)))
       and ($mf | all(req_match($fld))));
  [ $nodes.items[]
    | .metadata.name as $name | (.metadata.labels // {}) as $lbl | {"metadata.name": $name} as $fld
    | select( ($spec.nodeSelector // {}) | to_entries | all(. as $kv | $lbl[$kv.key] == $kv.value) )
    | select( ($spec.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms // null) as $terms
              | ($terms == null) or ($terms | any(term_match($lbl; $fld))) )
    | $name ] | sort | join(",")')

[ "$matching" = "$NODE" ] || {
  echo "ERR: the pod template's node selection allows nodes [${matching}], expected only the depot node"; exit 1; }

echo "OK: $DEP tolerates dedicated=depot:NoSchedule and can only be placed on the depot node"
exit 0
