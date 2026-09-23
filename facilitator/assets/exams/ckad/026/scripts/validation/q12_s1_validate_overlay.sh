#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
D=/home/candidate/exam/q12
O=$D/overlays/prod

K=""
for f in kustomization.yaml kustomization.yml Kustomization; do [ -f "$O/$f" ] && { K="$O/$f"; break; }; done
[ -n "$K" ] || { echo "FAIL: no kustomization file in $O"; exit 1; }

grep -Eq '\.\./\.\./base/?(["'"'"' ,]|\]|$)' "$K" || { echo "FAIL: $K must build on ../../base (listed under resources)"; exit 1; }

kubectl kustomize "$O" >/dev/null 2>&1 || { echo "FAIL: 'kubectl kustomize $O' does not render"; exit 1; }

# base/ and the staging overlay must be left as provided
while read -r sum file; do
  got=$(sha256sum "$D/$file" 2>/dev/null | cut -d' ' -f1)
  [ "$got" = "$sum" ] || { echo "FAIL: $file was modified or removed; only overlays/prod may be written"; exit 1; }
done <<'SUMS'
8d015c45f5e051116485588607dd0547b0e3fc9b1d2ec23a5b3bd8eed23888f2 base/deployment.yaml
787ecb860a00ff328dc0e7c63a51a74ad22fa957c3e842316cfd5f257df035bd base/kustomization.yaml
c9021616b15290eccc94dcd5a116a37e2a252c857634a96f3306aef12a567344 base/service.yaml
c00a474cdaf94840e9dee1cf81efe5fe05b784cd8e4e9db3bd66a3a7bd2d44ba overlays/staging/kustomization.yaml
3856f577da8c21ce5c7bb2f46db1e6aca8260f6a1df8c0dda0d54da8d3f50cda overlays/staging/web-limits.yaml
SUMS

echo "PASS: overlays/prod renders on top of ../../base and the provided files are unchanged"
exit 0
