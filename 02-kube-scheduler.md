```js
root@controlplane:~$ ps -ef | grep kube-scheduler
root        1818    1624  0 12:49 ?        00:00:16 kube-scheduler --authentication-kubeconfig=/etc/kubernetes/scheduler.conf --authorization-kubeconfig=/etc/kubernetes/scheduler.conf --bind-address=127.0.0.1 --kubeconfig=/etc/kubernetes/scheduler.conf --leader-elect=true
root        4245    3960  0 13:34 pts/0    00:00:00 grep --color=auto kube-scheduler
root@controlplane:~$ cat /etc/kubernetes/manifests/kube-scheduler.yaml 
apiVersion: v1
kind: Pod
metadata:
  labels:
    component: kube-scheduler
    tier: control-plane
  name: kube-scheduler
  namespace: kube-system
spec:
  containers:
  - command:
    - kube-scheduler
    - --authentication-kubeconfig=/etc/kubernetes/scheduler.conf
    - --authorization-kubeconfig=/etc/kubernetes/scheduler.conf
    - --bind-address=127.0.0.1
    - --kubeconfig=/etc/kubernetes/scheduler.conf
    - --leader-elect=true
    image: registry.k8s.io/kube-scheduler:v1.35.1
    imagePullPolicy: IfNotPresent
    livenessProbe:
      failureThreshold: 8
      httpGet:
        host: 127.0.0.1
        path: /livez
        port: probe-port
        scheme: HTTPS
      initialDelaySeconds: 10
      periodSeconds: 10
      timeoutSeconds: 15
    name: kube-scheduler
    ports:
    - containerPort: 10259
      name: probe-port
      protocol: TCP
    readinessProbe:
      failureThreshold: 3
      httpGet:
        host: 127.0.0.1
        path: /readyz
        port: probe-port
        scheme: HTTPS
      periodSeconds: 1
      timeoutSeconds: 15
    resources:
      requests:
        cpu: 25m
    startupProbe:
      failureThreshold: 24
      httpGet:
        host: 127.0.0.1
        path: /livez
        port: probe-port
        scheme: HTTPS
      initialDelaySeconds: 10
      periodSeconds: 10
      timeoutSeconds: 15
    volumeMounts:
    - mountPath: /etc/kubernetes/scheduler.conf
      name: kubeconfig
      readOnly: true
  hostNetwork: true
  priority: 2000001000
  priorityClassName: system-node-critical
  securityContext:
    seccompProfile:
      type: RuntimeDefault
  volumes:
  - hostPath:
      path: /etc/kubernetes/scheduler.conf
      type: FileOrCreate
    name: kubeconfig
status: {}
```

# kube-scheduler Analysis

## 1. PID là gì?

PID (Process ID) của `kube-scheduler` là:

```text
1818
```

Lấy từ output:

```bash
root        1818    1624  0 12:49 ?  00:00:16 kube-scheduler ...
```

---

# 2. Chạy trên secure port nào?

`kube-scheduler` đang chạy secure HTTPS port:

```text
10259
```

Lấy từ manifest:

```yaml
ports:
- containerPort: 10259
  name: probe-port
```

Các probe (`/livez`, `/readyz`) đều dùng:

```yaml
scheme: HTTPS
```

=> Đây là secure port.

---

# 3. etcd endpoint là gì?

`kube-scheduler` KHÔNG kết nối trực tiếp tới etcd.

Vì vậy:

```text
Không có etcd endpoint
```

Scheduler chỉ nói chuyện với:

```text
kube-apiserver
```

thông qua:

```bash
--kubeconfig=/etc/kubernetes/scheduler.conf
```

---

# 4. Authorization mode là gì?

Không xác định được từ output này.

Vì:

```text
--authorization-mode
```

là flag của `kube-apiserver`, không phải của scheduler.

Scheduler chỉ có:

```bash
--authorization-kubeconfig=/etc/kubernetes/scheduler.conf
```

Ý nghĩa:

- Scheduler dùng file kubeconfig này để authenticate/authorize với API Server.
- Không phải authorization mode thật sự.

---

# 5. TLS certificate file nằm ở đâu?

Không thấy flag:

```bash
--tls-cert-file
```

trong manifest.

Kubernetes sẽ tự động dùng certificate được sinh động (self-signed/generated cert).

Secure endpoint HTTPS vẫn hoạt động trên port `10259`.

---

# 6. Có phải Static Pod không?

✅ Có.

Vì manifest nằm trong thư mục:

```bash
/etc/kubernetes/manifests/
```

Kubelet sẽ tự động watch thư mục này và tạo Pod.

Manifest file:

```bash
/etc/kubernetes/manifests/kube-scheduler.yaml
```

---

# 7. Chạy trong namespace nào?

Chạy trong namespace:

```text
kube-system
```

Lấy từ:

```yaml
metadata:
  namespace: kube-system
```

---

# 8. kubelet dùng file nào để tạo Pod?

Kubelet dùng file:

```bash
/etc/kubernetes/manifests/kube-scheduler.yaml
```

để tạo Static Pod cho `kube-scheduler`.

---

# Tổng kết nhanh

| Thông tin | Giá trị |
|---|---|
| PID | `1818` |
| Secure Port | `10259` |
| etcd Endpoint | Không có |
| Authorization Mode | Không xác định từ scheduler |
| TLS Certificate File | Không khai báo explicit |
| Static Pod | ✅ Có |
| Namespace | `kube-system` |
| File kubelet dùng tạo Pod | `/etc/kubernetes/manifests/kube-scheduler.yaml` |


# How can kube-scheduler communicate without a TLS certificate?

This is a very important distinction in Kubernetes:

> `kube-scheduler` is mainly a **client**, not a public server.

So it does not need a manually configured serving certificate like `kube-apiserver`.

---

# 1. kube-scheduler mainly acts as a CLIENT

The scheduler connects TO the API Server:

```text
kube-scheduler  --->  kube-apiserver
```

using:

```bash
--kubeconfig=/etc/kubernetes/scheduler.conf
```

Inside `scheduler.conf` are:

- client certificate
- client key
- CA certificate
- API server endpoint

Example conceptually:

```yaml
users:
- name: system:kube-scheduler
  user:
    client-certificate: /etc/kubernetes/pki/scheduler.crt
    client-key: /etc/kubernetes/pki/scheduler.key
```

So the scheduler DOES use certificates.

But:

```text
It uses CLIENT certificates,
not SERVER certificates.
```

---

# 2. Difference: Client Cert vs Server Cert

| Type | Purpose |
|---|---|
| Server certificate | Proves "I am the real server" |
| Client certificate | Proves "I am an authorized client" |

---

# 3. kube-apiserver is BOTH server and client

The API Server:

## Acts as a SERVER

It receives HTTPS requests from:

- kubectl
- kubelet
- scheduler
- controller-manager

Therefore it needs:

```bash
--tls-cert-file
--tls-private-key-file
```

to prove its identity.

---

## Acts as a CLIENT

It also connects to:

- etcd
- kubelets

Therefore it also uses client certificates.

---

# 4. kube-scheduler is mostly CLIENT-only

Scheduler:

- watches Pods from API Server
- selects nodes
- updates Pod bindings via API Server

It does NOT expose a public API for other components.

Therefore:

```text
No external component needs to verify scheduler identity.
```

So a dedicated serving cert is usually unnecessary.

---

# 5. But kube-scheduler STILL exposes HTTPS on port 10259

This confuses many people.

It exposes:

```text
https://127.0.0.1:10259
```

for:

- `/livez`
- `/readyz`
- metrics
- health checks

BUT:

```text
Only locally on localhost.
```

because:

```bash
--bind-address=127.0.0.1
```

So Kubernetes can auto-generate a temporary self-signed cert internally.

No manually managed serving cert is needed.

---

# 6. Can kube-scheduler be both server and client?

Technically:

```text
YES
```

But in practice:

| Role | kube-scheduler |
|---|---|
| Client to API Server | ✅ Main role |
| Public API Server | ❌ No |
| Local HTTPS endpoint | ✅ Minimal/internal only |

---

# 7. Real-world analogy

## kube-apiserver

Like:

```text
A public government office
```

Everybody talks to it.

Needs:
- official passport
- identity verification
- public trust

---

## kube-scheduler

Like:

```text
An internal employee
```

It only:
- logs into the government office
- does internal work

So it only needs:
- employee ID (client cert)

not:
- a public-facing passport/server identity

---

# Final Summary

| Question | Answer |
|---|---|
| Does kube-scheduler use certificates? | ✅ Yes |
| What type? | Client certificates |
| Does it need `--tls-cert-file`? | Usually ❌ No |
| Why? | It is mainly a client |
| Can it expose HTTPS? | ✅ Yes, locally |
| Is it a full public server? | ❌ No |
| Main communication path | Scheduler → API Server |
