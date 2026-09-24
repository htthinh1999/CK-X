#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=dispatch
DIR=/home/candidate/exam/q12
APP="$DIR/app"

kubectl create namespace "$NS" --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

# Start from a clean state (idempotent re-runs)
kubectl -n "$NS" delete deployment dispatch-board --ignore-not-found >/dev/null 2>&1 || true
rm -rf "$DIR" && mkdir -p "$APP"

cat > "$APP/Dockerfile" <<'EOF'
# Dispatch board front page
ARG BASE_TAG=1.25
ARG DISPATCH_ZONE=central

FROM nginx:${BASE_TAG}

ARG BUILD_NO=100

LABEL transit.dispatch/zone="${DISPATCH_ZONE}" \
      transit.dispatch/build="${BUILD_NO}" \
      transit.dispatch/release="${DISPATCH_ZONE}-${BUILD_NO}"

COPY index.html /usr/share/nginx/html/index.html
RUN sed -i "s/__ZONE__/${DISPATCH_ZONE}/; s/__BUILD__/${BUILD_NO}/" /usr/share/nginx/html/index.html
EOF

cat > "$APP/index.html" <<'EOF'
<!DOCTYPE html>
<html>
<head><title>Dispatch Board</title></head>
<body>
<h1>Dispatch Board</h1>
<p id="release">zone=__ZONE__ build=__BUILD__</p>
</body>
</html>
EOF

# Fresh local registry (drops anything pushed by a previous attempt)
docker rm -f -v registry >/dev/null 2>&1 || true
docker rmi -f localhost:5000/dispatch-board:2.3 localhost:5000/dispatch-board:2.2 >/dev/null 2>&1 || true
docker run -d -p 5000:5000 --restart=always --name registry registry:2 >/dev/null 2>&1 || true
for i in $(seq 1 30); do
  curl -sf --max-time 2 http://localhost:5000/v2/ >/dev/null 2>&1 && break
  sleep 1
done

# The previous release (2.2) is already published; warm the base image cache
if timeout 300 docker pull nginx:1.25 >/dev/null 2>&1; then
  docker tag nginx:1.25 localhost:5000/dispatch-board:2.2 >/dev/null 2>&1 \
    && timeout 120 docker push localhost:5000/dispatch-board:2.2 >/dev/null 2>&1 || true
  docker rmi localhost:5000/dispatch-board:2.2 >/dev/null 2>&1 || true
fi

echo "Setup complete for Question 12"
exit 0
