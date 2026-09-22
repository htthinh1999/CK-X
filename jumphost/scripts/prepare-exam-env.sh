#!/bin/bash
exec >> /proc/1/fd/1 2>&1


# Log function with timestamp
log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Set defaults
NUMBER_OF_NODES=${1:-1}
EXAM_ID=${2:-""}
# Optional multi-cluster spec: comma-separated "name:workers" pairs, e.g.
#   "cluster1:1,cluster2:0"
# When empty, a single cluster named "$CLUSTER_NAME" with $NUMBER_OF_NODES
# workers is created (legacy, unchanged behaviour).
CLUSTER_SPEC=${3:-""}

echo "Exam ID: $EXAM_ID"
echo "Number of nodes: $NUMBER_OF_NODES"
echo "Cluster spec: ${CLUSTER_SPEC:-<single>}"

# Clear any stale per-host cluster marker from a previous (multi-cluster) exam so
# this host falls back to the shared kubeconfig. For multi-cluster exams the
# facilitator re-writes the correct marker on each server after clusters are up.
rm -f /home/candidate/.exam-cluster

#check docker is running
if ! docker info > /dev/null 2>&1; then
  log "Docker is not running"
  log "Attempting to start docker"
  dockerd &
  sleep 5
  #check docker is running 3 times with 5 second interval
  for i in {1..3}; do
    if docker info > /dev/null 2>&1; then
      log "Docker started successfully"
      break
    fi
    log "Docker failed to start, retrying..."
    sleep 5
  done
fi

log "Starting exam environment preparation with $NUMBER_OF_NODES node(s)"

# Validate input
if ! [[ "$NUMBER_OF_NODES" =~ ^[0-9]+$ ]]; then
  log "ERROR: Number of nodes must be a positive integer"
  exit 1
fi

# ---------------------------------------------------------------------------
# Provision cluster(s) on the k8s-api-server host
# ---------------------------------------------------------------------------
MULTI=0
if [ -z "$CLUSTER_SPEC" ]; then
  # Legacy single-cluster path (unchanged)
  ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null candidate@k8s-api-server "env-setup $NUMBER_OF_NODES $CLUSTER_NAME"
else
  # Multi-cluster path: create one cluster per "name:workers" pair, each on a
  # distinct API port (6443 + index).
  MULTI=1
  idx=0
  CLUSTER_NAMES=""
  OLDIFS=$IFS
  IFS=','
  for pair in $CLUSTER_SPEC; do
    # pair = name[:workers[:server]]
    cname=${pair%%:*}
    CLUSTER_NAMES="$CLUSTER_NAMES $cname"
    rest=${pair#*:}
    [ "$rest" = "$pair" ] && rest=0          # no ":" -> default 0 workers
    cworkers=${rest%%:*}
    cserver=""
    [ "$rest" != "$cworkers" ] && cserver=${rest#*:}
    cserver=${cserver:-ckad9999}             # server whose registry this cluster pulls from
    log "Creating cluster '$cname' (workers=$cworkers, index=$idx, registry host=$cserver)"
    ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null candidate@k8s-api-server "env-setup $cworkers $cname $idx $cserver"
    idx=$((idx+1))
  done
  IFS=$OLDIFS
fi

#Pull assets from URL
curl facilitator:3000/api/v1/exams/$EXAM_ID/assets -o assets.tar.gz

mkdir -p /tmp/exam-assets
#Unzip assets (shared volume in multi-server deployments so every server sees them)
tar -xzvf assets.tar.gz -C /tmp/exam-assets

#Remove assets.tar.gz
rm assets.tar.gz

#make every file in /tmp/exam-assets executable
find /tmp/exam-assets -type f -exec chmod +x {} \;

echo "Exam assets downloaded and prepared successfully"

export KUBECONFIG=/home/candidate/.kube/kubeconfig

sleep 5

#wait till api-server is ready
if [ "$MULTI" = "1" ]; then
  # Multi-cluster: wait on EVERY cluster through its own per-cluster kubeconfig
  # (the merged file's current-context only covers one of them).
  for cname in $CLUSTER_NAMES; do
    kc=/home/candidate/.kube/kubeconfig-$cname
    until [ -f "$kc" ] && KUBECONFIG="$kc" kubectl get nodes > /dev/null 2>&1; do
      log "API server for cluster '$cname' is not ready, retrying..."
      sleep 5
    done
    log "API server for cluster '$cname' is ready"
  done
else
  while ! kubectl get nodes > /dev/null 2>&1; do
    log "API server is not ready, retrying..."
    sleep 5
  done
fi

echo "API server is ready"

# Run setup scripts.
# - Single-cluster (legacy): run every setup script here on this jumphost, as before.
# - Multi-server: the facilitator runs each question's setup script on that
#   question's target server (with the right cluster context), so we skip the
#   local loop here.
if [ "$MULTI" = "0" ]; then
  for script in /tmp/exam-assets/scripts/setup/q*_setup.sh; do $script; done
else
  log "Multi-server exam: setup scripts will be run per-server by the facilitator"
fi

log "Exam environment preparation completed successfully"
exit 0
