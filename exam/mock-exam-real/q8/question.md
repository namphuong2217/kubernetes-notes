# Question 8 — Install a CNI That Enforces Network Policy

## Background

A Kubernetes cluster has been initialized but no Container Network Interface (CNI) has been installed yet.

Your task is to install a CNI plugin that satisfies the following requirements.

---

## Tasks

Install and configure a CNI from a **manifest** (not Helm).

Choose one of the following:

- Flannel v0.27.0 (`kube-flannel.yml`)
- Calico v3.29.1 (`tigera-operator.yaml`)

The selected CNI must satisfy all of the following:

1. Pods must be able to communicate across nodes.

2. Kubernetes NetworkPolicy must be enforced.

3. The installation must use Kubernetes manifests.

Helm is **not** allowed.

---

## Validation

After the installation completes, verify that:

- All nodes are Ready.
- Calico components are Running.
- Tigera components are Available.