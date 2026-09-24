#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
REG=http://localhost:5000
REPO=dispatch-board
TAG=2.3
ACCEPT="application/vnd.docker.distribution.manifest.v2+json, application/vnd.oci.image.manifest.v1+json, application/vnd.docker.distribution.manifest.list.v2+json, application/vnd.oci.image.index.v1+json"

tags=$(curl -sf --max-time 10 "$REG/v2/$REPO/tags/list" 2>/dev/null) || { echo "ERR: repository $REPO not found in the registry at localhost:5000"; exit 1; }
echo "$tags" | jq -e --arg t "$TAG" '(.tags // []) | index($t) != null' >/dev/null 2>&1 \
  || { echo "ERR: tag $TAG not pushed (tags: $(echo "$tags" | jq -c '.tags'))"; exit 1; }

man=$(curl -sf --max-time 10 -H "Accept: $ACCEPT" "$REG/v2/$REPO/manifests/$TAG" 2>/dev/null) || { echo "ERR: cannot fetch manifest $REPO:$TAG"; exit 1; }
# Multi-platform index / manifest list (e.g. with attestations): pick the real linux image
if echo "$man" | jq -e 'has("manifests")' >/dev/null 2>&1; then
  d=$(echo "$man" | jq -r '[.manifests[] | select((.platform.os // "linux") == "linux" and (.platform.architecture // "") != "unknown")][0].digest // empty')
  [ -n "$d" ] || { echo "ERR: no linux image in the $REPO:$TAG index"; exit 1; }
  man=$(curl -sf --max-time 10 -H "Accept: $ACCEPT" "$REG/v2/$REPO/manifests/$d" 2>/dev/null) || { echo "ERR: cannot fetch manifest $d"; exit 1; }
fi
cfg=$(echo "$man" | jq -r '.config.digest // empty')
[ -n "$cfg" ] || { echo "ERR: manifest of $REPO:$TAG has no config"; exit 1; }
blob=$(curl -sfL --max-time 10 "$REG/v2/$REPO/blobs/$cfg" 2>/dev/null) || { echo "ERR: cannot fetch image config $cfg"; exit 1; }

zone=$(echo "$blob" | jq -r '.config.Labels["transit.dispatch/zone"] // empty')
build=$(echo "$blob" | jq -r '.config.Labels["transit.dispatch/build"] // empty')
rel=$(echo "$blob" | jq -r '.config.Labels["transit.dispatch/release"] // empty')
[ "$zone" = "riverside" ] || { echo "ERR: pushed image label transit.dispatch/zone='$zone', expected riverside"; exit 1; }
[ "$build" = "417" ] || { echo "ERR: pushed image label transit.dispatch/build='$build', expected 417"; exit 1; }
[ "$rel" = "riverside-417" ] || { echo "ERR: pushed image label transit.dispatch/release='$rel', expected riverside-417"; exit 1; }

echo "OK: localhost:5000/$REPO:$TAG is pushed with zone=riverside build=417"
exit 0
