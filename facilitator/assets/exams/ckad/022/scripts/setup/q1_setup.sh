#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace apex --dry-run=client -o yaml | kubectl apply -f - || true
mkdir -p /tmp/exam/course/1
cat > /tmp/exam/course/1/main.go <<'GO'
package main
import "fmt"
func main() { fmt.Println("Hello Dojo") }
GO
cat > /tmp/exam/course/1/Dockerfile <<'DOCKER'
FROM nginx:alpine
# TODO
DOCKER
# Start a throwaway local registry so docker push to localhost:5000 works
docker rm -f registry 2>/dev/null; docker run -d -p 5000:5000 --restart=always --name registry registry:2 >/dev/null 2>&1 || true
echo "Setup complete for Question 1"
exit 0
