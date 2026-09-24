#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=fares; DEP=fare-board; C=board; MP=/usr/share/nginx/html/fares

json=$(kubectl -n "$NS" get deployment "$DEP" -o json 2>/dev/null) || { echo "ERR: Deployment $DEP not found"; exit 1; }

res=$(echo "$json" | jq -r --arg c "$C" --arg mp "$MP" '
  .spec.template.spec as $s
  | ([$s.containers[] | select(.name==$c)][0]) as $ctr
  | if $ctr == null then "ERR: container \($c) not found" else
    # volumes that project ConfigMap fare-table (plain configMap or projected)
    ([$s.volumes[]? | select((.configMap.name == "fare-table") or ([.projected.sources[]?.configMap.name] | index("fare-table")))]) as $fv
    | ([$fv[].name]) as $fnames
    | ([$ctr.volumeMounts[]? | select(.name as $n | $fnames | index($n))]) as $fm
    | if ([$ctr.volumeMounts[]? | select((.subPath // "") != "" or (.subPathExpr // "") != "") | select(.name as $n | $fnames | index($n))] | length) > 0
        then "ERR: a fare-table mount still uses subPath"
      elif ($fm | length) != 1 then "ERR: expected exactly one mount of a fare-table volume in container \($c), found \($fm | length)"
      elif (($fm[0].mountPath | sub("/+$"; "")) != $mp) then "ERR: fare-table volume is mounted at \($fm[0].mountPath), expected \($mp)"
      else
        ([$fv[] | select(.name == $fm[0].name)][0]) as $v
        | (if $v.configMap then $v.configMap.items
           else ([$v.projected.sources[] | select(.configMap)] | if length == 1 then .[0].configMap.items else "multi" end) end) as $items
        | if $items == "multi" then "ERR: projected volume combines several sources"
          elif ($items == null) then "ERR: volume \($v.name) projects every key of fare-table (no items), the directory would also contain night.txt"
          elif (([$items[] | {key, path}] | sort_by(.key)) != [{"key":"offpeak.txt","path":"offpeak.txt"},{"key":"peak.txt","path":"current.txt"}])
            then "ERR: items of volume \($v.name) must map exactly peak.txt->current.txt and offpeak.txt->offpeak.txt, got \([$items[] | "\(.key)->\(.path)"] | join(","))"
          else "OK" end
      end
    end')

[ "$res" = "OK" ] || { echo "$res"; exit 1; }
echo "OK: fare-table mounted as directory $MP with items peak.txt->current.txt, offpeak.txt->offpeak.txt, no subPath"
exit 0
