#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

kubectl create namespace lunar --dry-run=client -o yaml | kubectl apply -f - || true

mkdir -p /tmp/exam/course/1
cat > /tmp/exam/course/1/Dockerfile <<'EOF'
FROM golang:1.20-alpine
# Add instructions below
EOF

cat > /tmp/exam/course/1/main.go <<'EOF'
package main
import "fmt"
func main() {
    fmt.Println("Tsukuyomi server running")
}
EOF

echo "Setup complete for Question 1"
exit 0
