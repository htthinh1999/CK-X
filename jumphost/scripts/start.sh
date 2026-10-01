#!/bin/bash
# Jumphost container start: SSH server plus a nested Docker daemon (docker-in-docker).

# cgroup v2 hosts (Docker Desktop / WSL2, recent Linux): make the cgroup tree
# nestable so containers started by this host's dockerd can run. Same steps as
# the official docker:dind image: move every process out of the root cgroup,
# then delegate all controllers to child cgroups. Retried because new processes
# can land in the root cgroup between the two steps.
if [ -f /sys/fs/cgroup/cgroup.controllers ]; then
    mkdir -p /sys/fs/cgroup/init
    for _ in $(seq 1 100); do
        xargs -rn1 < /sys/fs/cgroup/cgroup.procs > /sys/fs/cgroup/init/cgroup.procs 2>/dev/null || :
        sed -e 's/ / +/g' -e 's/^/+/' < /sys/fs/cgroup/cgroup.controllers \
            > /sys/fs/cgroup/cgroup.subtree_control 2>/dev/null && break
    done
fi

service ssh start

# A restarted container keeps /var/run from its previous run. A stale pid file
# makes dockerd refuse to start ("process with PID N is still running"), and
# every docker command then fails with "Is the docker daemon running?".
rm -f /var/run/docker.pid /var/run/docker/containerd/containerd.pid

dockerd_pid=
trap '[ -n "$dockerd_pid" ] && kill "$dockerd_pid" 2>/dev/null; wait; exit 0' TERM INT

# Keep dockerd running: restart it if it ever exits.
while true; do
    dockerd &
    dockerd_pid=$!
    wait "$dockerd_pid"
    echo "jumphost: dockerd exited with status $?, restarting in 3s" >&2
    sleep 3
done
