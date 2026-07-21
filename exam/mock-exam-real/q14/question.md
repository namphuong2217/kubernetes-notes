# Question 14 — Fix a Broken kube-apiserver → etcd Connection

## Background

After migrating the control-plane node to new hardware, kube-apiserver fails to start.

Before the migration, etcd was external; after migration, the `--etcd-servers` flag was accidentally pointed at the wrong IP address (the old node's IP instead of the new etcd endpoint).

---

## Tasks

- Diagnose why **kube-apiserver** is failing.

- Correct the etcd endpoint so the API server starts successfully again.

---

## Validation

After completing the task, verify your solution:

```bash
./verify.sh
```