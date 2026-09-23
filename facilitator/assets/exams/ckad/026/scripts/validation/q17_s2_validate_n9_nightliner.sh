#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=manifests; NAME=n9-nightliner

json=$(kubectl -n "$NS" get routes.transit.example.com "$NAME" -o json 2>/dev/null) || { echo "ERR: Route $NAME (transit.example.com) not found in $NS"; exit 1; }
got=$(echo "$json" | jq -cS '.spec')
want=$(jq -cnS '{line: "N9", mode: "bus", stops: 31, depot: "north", serviceClass: "C5", frequencyMinutes: 20}')
if [ "$got" != "$want" ]; then
  cls=$(echo "$json" | jq -r '.spec.serviceClass // "unset"')
  echo "ERR: spec of $NAME is $got, expected $want (serviceClass '$cls' must be the code documented for a night network service)"
  exit 1
fi

echo "OK: Route $NAME has the expected spec"
exit 0
