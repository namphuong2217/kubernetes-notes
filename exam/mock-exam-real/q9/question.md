# Question 9 — Configure containerd and Kernel Parameters

## Background

Configure a node so it is ready to join a Kubernetes cluster using **containerd** as the container runtime.

---

## Tasks

- Install the package:

  ```
  ~/runc.deb
  ```

  using `dpkg`.

- Enable and start the `containerd` service.

- Configure the following kernel parameters:

  ```
  net.bridge.bridge-nf-call-iptables = 1
  net.bridge.bridge-nf-call-ip6tables = 1
  net.ipv4.ip_forward = 1
  net.netfilter.nf_conntrack_max = 262144
  ```

---

## Validation

After completing the task, verify your solution:

```bash
./verify.sh
```