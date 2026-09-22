#!/bin/bash
exec >> /proc/1/fd/1 2>&1

# cleanup-exam-env.sh
# 
# This script cleans up the exam environment on the jumphost.
# It removes all resources created during the exam to prepare for a new exam.
#
# Usage: cleanup-exam-env.sh
#
# Example: cleanup-exam-env.sh

# Log function with timestamp
log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

log "Starting exam environment cleanup"
log "Cleaning up all clusters"
# Delete every cluster (multi-cluster exams create more than one) for a full reset.
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null candidate@k8s-api-server "env-cleanup all"

#cleanup docker env
log "Cleaning up docker environment"
docker system prune -a --volumes -fa
docker network prune -fa
docker image prune -fa

# Remove the exam environment directory
log "Removing exam environment directory"
rm -rf /tmp/exam-env
rm -rf /tmp/exam

# Clear the exam assets (this is a shared volume mount — clear its contents,
# not the mount point itself, so the next exam repopulates it for all servers).
log "Clearing exam assets"
rm -rf /tmp/exam-assets/* /tmp/exam-assets/.[!.]* 2>/dev/null || true

log "Exam environment cleanup completed successfully"
exit 0 