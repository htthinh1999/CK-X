#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
f=/home/candidate/exam/q13/foghorn.log
[ -s "$f" ] || { echo "FAIL: $f is missing or empty"; exit 1; }
# nginx access log line, e.g.: 10.42.0.9 - - [..] "GET / HTTP/1.1" 200 615 "-" "Wget" "-"
if grep -q '"GET /' "$f"; then
  echo "OK: $f contains an nginx GET access log line"
  exit 0
fi
echo "FAIL: $f does not contain a GET request line from the foghorn pod logs"
exit 1
