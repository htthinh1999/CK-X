#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
f=/tmp/exam/course/11/sidecar-logs.txt
if [ ! -f "$f" ]; then echo "Error: file not found"; exit 1; fi
lc=$(wc -l <"$f" 2>/dev/null)
hs=$(grep -c "sidecar" "$f" 2>/dev/null || true)
if [ "$lc" -gt 0 ] && [ "$hs" -gt 0 ]; then echo "Success: file contains sidecar logs ($lc lines)"; exit 0; else echo "Error: file lacks sidecar log content"; exit 1; fi
