# Kubernetes Control Plane: Communication and Security

## 1. API Server and etcd Communication

The `kube-apiserver` communicates with `etcd` locally on the same machine (controlplane node) using the loopback interface (`localhost`).

### Visual Representation

Both processes run inside the same node and communicate via `127.0.0.1:2379`.

```text
┌───────────────────────────────────────────────────┐
│              Node: controlplane                   │
│              IP: 172.30.1.2                       │
│                                                   │
│  ┌───────────────────┐      ┌───────────────┐     │
│  │  kube-apiserver   │      │     etcd      │     │
│  │   port: 6443      │      │  port: 2379   │     │
│  └─────────┬─────────┘      └───────▲───────┘     │
│            │                        │             │
│            └────────────────────────┘             │
│                  127.0.0.1:2379                   │
│                   (localhost)                     │
└───────────────────────────────────────────────────┘
```

### Why use localhost instead of the Node IP (`172.30.1.2`)?

While etcd listens on the node IP, `127.0.0.1` is preferred for the following reasons:

| Reason | Explanation |
|---|---|
| Security | Traffic on `127.0.0.1` never leaves the machine; nothing external can intercept it. |
| Performance | The loopback interface is slightly faster as no real network hardware is involved. |
| Best Practice | etcd contains all cluster data; it should be as locked down as possible. |

### Analogy

- **Node IP (`172.30.1.2`)**: Like two people in the same room calling each other via a public phone line. It works, but others could listen.
- **Localhost (`127.0.0.1`)**: Like talking directly across the desk. It is faster, private, and secure.

---

# 2. Inspecting kube-controller-manager

## Insights from `ps -ef` Output

### PID
- `1799`  
  (The second column in the process list).

### API Server Secure Port
Cannot answer from this output.

This flag exists on `kube-apiserver`, not the controller-manager.

(Standard is `6443`).

### etcd Endpoint
Cannot answer from this output.

The controller-manager does **not** connect directly to etcd.

### Authorization Mode
Not applicable here.

`--authorization-mode` is an API server flag.

The flags `--authentication-kubeconfig` and `--authorization-kubeconfig` found here only tell the manager how to identify itself to the API server.

### TLS Certificate Location
There is no `--tls-cert-file` flag because the controller-manager does not serve HTTPS traffic to external clients.

It only uses CA files (e.g., `/etc/kubernetes/pki/ca.crt`) to verify other components.

---

## Insights from `kube-controller-manager.yaml`

### Static Pod
Yes.

The file is located in:

```bash
/etc/kubernetes/manifests/
```

(watched by kubelet).

The Pod name will be suffixed with the node name at runtime:

```text
kube-controller-manager-controlplane
```

### Namespace

```text
kube-system
```

### Manifest File

```bash
/etc/kubernetes/manifests/kube-controller-manager.yaml
```

### Option `--etcd-servers`

This option does **not** exist in the controller-manager.

---

## Architectural Rule: etcd Access

Only the API Server is allowed to talk to etcd.

All other components must go through the API Server.

| Component | Talks to etcd directly? | Connection Method |
|---|---|---|
| kube-apiserver | ✅ Yes | `--etcd-servers` |
| kube-controller-manager | ❌ No | `--kubeconfig` (to API Server) |
| kube-scheduler | ❌ No | `--kubeconfig` (to API Server) |
| kubelet | ❌ No | `--kubeconfig` (to API Server) |

---

# 3. Security Deep Dive: CA vs. TLS Certificates

## The Core Analogy: Government ID System

- **CA Certificate** = The Government  
  They issue and verify IDs/passports but don't travel themselves.

- **TLS Certificate** = Your Passport  
  Proves who you are when you travel.

---

## TLS Certificate ("I am who I say I am")

Used by components that serve traffic (like the API Server).

When a user connects via HTTPS, the server shows its TLS cert (e.g., `apiserver.crt`) to prove its identity.

---

## CA Certificate ("I verify everyone's identity")

Used by components to check the identity of others.

The controller-manager uses `ca.crt` to verify that the API Server it is connecting to is legitimate.

---

## Analysis of Controller-Manager CA Flags

### `--client-ca-file`

Used to verify certificates of clients connecting to the controller-manager.

### `--cluster-signing-cert-file`

Allows the controller-manager to sign and issue new certificates.

Like a government office issuing new passports for new nodes/kubelets.

### `--requestheader-client-ca-file`

A specific CA for the front-proxy aggregation layer.

### `--root-ca-file`

The master CA injected into every Pod so they can trust the API Server.

---

# Side-by-Side Comparison

## kube-apiserver

- Has `--tls-cert-file`
    - Shows passport to visitors.

- Has `--client-ca-file`
    - Checks visitors' passports.

- Acts as both:
    - Passport holder and checker.

---

## kube-controller-manager

- No `--tls-cert-file`
    - Does not greet external visitors.

- Has `--client-ca-file`
    - Checks others' passports.

- Has `--cluster-signing`
    - Can issue new passports.

- Acts as:
    - Passport checker and issuer.

---

# Why does the controller-manager lack a TLS cert?

Because it functions as a client.

It reaches out to the API server; nothing from the outside reaches in to it directly.

