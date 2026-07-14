# Miscellaneous

### Hoc thuoc long
```cmd
annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
```
### Allowed resources
https://docs.linuxfoundation.org/tc-docs/certification/certification-resources-allowed

### Chu de khong thi
1. Không có upgrade cluster
2. Không có backup &resotore etcd
3. 

### Find control by
```cmd
controlplane ~ ✖ kubectl describe pod kube-proxy-2k98f -n kube-system | grep -i 'by'
Controlled By:  DaemonSet/kube-proxy
```

### Networking
```cmd
nestat --help
n
l
p/a
```

### Troubleshoot commands
```cmd
k get ns -owide --show-labels
```

### Resources
kubectl exec internal -- curl http://external-service:8080
Nợ: kubernetes.io/metadata.name
k api-resources

# Q1. RBAC (Role-Based Access Control)


**Question 1** (1/18) — *Task weight: 3%*

**Set configuration context:**

```
student@kube4sure:~$ kubectl config use-context k8s
```

**Context:**

You have been asked to create a new ClusterRole for a deployment pipeline and bind it to a specific ServiceAccount scoped to a specific namespace.

**Task:**

Create a new ClusterRole named `deployment-clusterrole`, which only allows to create the following resource types:

- Deployment
- StatefulSet
- DaemonSet

Create a new ServiceAccount named `cicd-token` in the existing namespace `app-team1`.

Bind the new ClusterRole `deployment-clusterrole` to the new ServiceAccount `cicd-token`, limited to the namespace `app-team1`.

**Hint 💡**

Create a new ClusterRole which can be used with the `kubectl create` command. Then, create a new ServiceAccount and RoleBinding.

---

### Solution 🔥

Use the `kubectl create` command to create a new ClusterRole:

```
student@kube4sure:~$ kubectl create clusterrole deployment-clusterrole --verb=create --resource=deployments,statefulsets,daemonsets
```

Create a new ServiceAccount:

```
student@kube4sure:~$ kubectl create serviceaccount cicd-token --namespace=app-team1
```

Create a new RoleBinding:

```
student@kube4sure:~$ kubectl create rolebinding deployment-binding --clusterrole=deployment-clusterrole --serviceaccount=app-team1:cicd-token --namespace=app-team1
```

Verify it's created correctly:

```
student@kube4sure:~$ kubectl auth can-i create deployment -n app-team1 --as system:serviceaccount:app-team1:cicd-token
yes
student@kube4sure:~$ kubectl auth can-i create deployment -n default --as system:serviceaccount:app-team1:cicd-token
no
```

---

### Explanation & Correctness Check

| Step | Command | Verdict |
|---|---|---|
| Create ClusterRole | `--verb=create --resource=deployments,statefulsets,daemonsets` | ✅ Correct |
| Create ServiceAccount | `--namespace=app-team1` | ✅ Correct |
| Create RoleBinding (not ClusterRoleBinding) | binds ClusterRole via a namespaced RoleBinding | ✅ Correct — this is the key trick of the question |
| Verify with `auth can-i --as` | checks both in-namespace and out-of-namespace | ✅ Correct |

**Details:**

- **ClusterRole creation** — Restricting `--verb` to only `create` satisfies "only allows to **create**." Listing all three resources in one `--resource=` flag (comma-separated) is the correct, idiomatic way to grant the same verb across multiple resource types in a single ClusterRole.
- **ServiceAccount creation** — Straightforward; correctly placed in `app-team1`.
- **RoleBinding vs. ClusterRoleBinding (the core of this question)** — A **RoleBinding** (not a ClusterRoleBinding) is used to bind a **ClusterRole**. This is the standard pattern for "reuse a cluster-wide role definition, but scope the grant to one namespace." A RoleBinding referencing a ClusterRole only grants the permissions within the RoleBinding's own namespace — exactly what "limited to the namespace `app-team1`" requires. Using a **ClusterRoleBinding** here would have been **wrong**, since that would grant the permissions cluster-wide across *all* namespaces.
- **Verification** — Impersonating the ServiceAccount and checking `create deployment` in `app-team1` (→ `yes`) and in `default` (→ `no`) correctly proves the permission is scoped only to `app-team1`.

# Q2. Section: 🔧 Cluster Maintenance

**Question 2** (2/18) — *Task weight: 3%*

**Set configuration context:**

```
student@kube4sure:~$ kubectl config use-context ek8s
```

**Context:**

Set the node named `ek8s-worker` as unavailable and reschedule all the pods running on it.

**Hint 💡**

Use the `kubectl drain` command to drain node.

---

### Solution 🔥

Check status all the nodes in the cluster

```
student@kube4sure:~$ kubectl get nodes
NAME                 STATUS   ROLES           AGE   VERSION
ek8s-control-plane   Ready    control-plane   26m   v1.26.6
ek8s-worker          Ready    <none>          26m   v1.26.6
```

Use the `kubectl drain` command to drain node in the cluster

```
student@kube4sure:~$ kubectl drain ek8s-worker --ignore-daemonsets --delete-emptydir-data
```

Check status all the nodes again

```
student@kube4sure:~$ kubectl get nodes
NAME                 STATUS                     ROLES           AGE   VERSION
ek8s-control-plane   Ready                      control-plane   27m   v1.26.6
ek8s-worker          Ready,SchedulingDisabled    <none>          27m   v1.26.6
```

### Remarks — Các khái niệm liên quan

Lệnh `kubectl drain` sẽ:

1. **Mark node as unschedulable** (cordon)
2. **Evict pods**
3. **Scheduler** reschedule pods sang node khác

**Flow thực tế:**

```
kubectl drain node
       ↓
Node SchedulingDisabled
       ↓
Pods bị evict
       ↓
Scheduler tạo pod mới trên node khác
```

# Q5. Networking (NetworkPolicy)

**Question 5** (5/18) — *Task weight: 7%*

**Set configuration context:**
student@kube4sure:~# kubectl config use-context k8s

**Context:**

Create a new NetworkPolicy named `allow-port-from-namespace` in the existing namespace `fubar`.

Ensure that the new NetworkPolicy allows Pods in namespace `internal` to connect to port `9000` of Pods in namespace `fubar`.

Further ensure that the new NetworkPolicy:

- does not allow access to Pods, which don't listen on port `9000`
- does not allow access from Pods, which are not in namespace `internal`

**Hint 💡**

Firstly, we need to set a label for the namespace. Then, we only create a NetworkPolicy which matches the label we created before.

---

### Solution 🔥

Create the NetworkPolicy as follows:

student@kube4sure:~# vim np.yaml
**np.yaml**

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-port-from-namespace
  namespace: fubar
spec:
  podSelector: {}
  policyTypes:
    - Ingress
  ingress:
    - from:
        - namespaceSelector:
            matchLabels:
              kubernetes.io/metadata.name: internal
      ports:
        - protocol: TCP
          port: 9000
```
student@kube4sure:~# kubectl create -f np.yaml

### Remarks

1. B1. Tôi cần NetPod cho Pod nào?
2. B2. Xác định Ingress / Egress
3. B3. Implement

B1: Pods trên fubar
B2. Ingress (access to)
```cmd
Verify Ingress cho Pod nào đó: 
kubectl run tmp --rm -it --restart=Never --image=busybox -- nc -vz -w 3 external-service 8080
kubectl run tmp --rm -it --restart=Never --image=busybox -- nc -vz -w 3 172.17.0.5 8080
```

The solution is correct, with one small note about the hint:

- `namespace: fubar`, empty `podSelector: {}` — correctly targets all pods in fubar, and an empty selector is required since the policy must apply namespace-wide (not to a specific labeled pod).
- `policyTypes: [Ingress]` — correct, since only inbound traffic needs restricting.
- `ports: [{protocol: TCP, port: 9000}]` — correctly scopes the allow rule to port 9000 only. This is what satisfies "does not allow access to Pods which don't listen on port 9000" — traffic to any other port from any source is not permitted by this rule (and since Ingress is listed as the only policyType, all other ingress traffic to fubar pods is now denied by default, which is the intended lock-down).
- `namespaceSelector.matchLabels: kubernetes.io/metadata.name: internal` — this correctly restricts the "from" side to only pods in the internal namespace, satisfying "does not allow access from Pods which are not in namespace internal".

One inconsistency to flag: The Hint says "we need to set a label for the namespace first", implying a manual `kubectl label namespace internal <key>=<value>` step. But the actual solution uses the automatic, built-in immutable label `kubernetes.io/metadata.name`, which Kubernetes (v1.21+) applies to every namespace automatically — matching it to the namespace's own name (internal). So no manual labeling step is actually required for this solution to work, despite what the hint suggests. This is only valid on clusters where that automatic label exists (Kubernetes 1.21 or later); on older clusters you'd need to manually label the internal namespace instead.

# Q11 Storage
## Context
Create a persistent volume with name `app-data`. of capacity `2Gi` and access mode `ReadOnlyMany`. The typ of volum is `hostPath` and its location is `/srv/app-data`
https://kubernetes.io/docs/tutorials/configuration/configure-persistent-volume-storage/ 
## Solution
```cmd
root@controlplane:~$ vi kube4sure_11.yaml
root@controlplane:~$ k apply -f kube4sure_11.yaml 
persistentvolume/app-data created
root@controlplane:~$ k get pv
NAME       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM   STORAGECLASS   VOLUMEATTRIBUTESCLASS   REASON   AGE
app-data   2Gi        ROX            Retain           Available                          <unset>                          4s
root@controlplane:~$ cat kube4sure_11.yaml 
apiVersion: v1
kind: PersistentVolume
metadata:
  name: app-data
spec:
  capacity:
    storage: 2Gi
  accessModes:
  - ReadOnlyMany
  hostPath:
    path: "/srv/app-data"
```
# Q17 Ingress

## Context

Create a new nginx Ingress resource as follows:

- Name: `pong`
- Namespace: `ing-internal`
- Exposing service hello on path `/hello` using service port 5678

## Solution

```cmd
vi ingress-internal.yaml

apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: pong
  namespace: ing-internal
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
spec:
  ingressClassName: nginx
  rules:
  - http:
      paths:
      - pathType: Prefix
        path: /hello
        backend:
          service:
            name: hello
            port:
              number: 5678
              
k create -f ingress-internal.yaml
```

```cmd
controlplane ~ ➜  k create ingress -h | grep -i "rewrite" -C5

controlplane ~ ✖  kubectl create ingress annotated --class=default --rule="foo.com/bar=svc:port" \
  --annotation ingress.annotation1=foo \
  --annotation ingress.annotation2=bl --dry-run=client -oyaml > template.yaml
```


## Q18. Cluster Architecture, Installation & Configuration (Cluster Troubleshooting)

**Question 18** (18/18) — *Task weight: 13%*

**Set configuration context:**

```
student@kube4sure:~# kubectl config use-context mk8s
```

**Context:**

A Kubernetes worker node, named `mk8s-worker`, is in state `NotReady`. Investigate why this is the case, and perform any appropriate steps to bring the node to a `Ready` state, ensuring that any changes are made permanent.

You can ssh to the failed node using:

```
student@kube4sure:~# ssh mk8s-worker
```

You can assume elevated privileges on the node with the following command:

```
student@mk8s-worker:~# sudo -i
```

**Hint 💡**

Check the status of the Kubelet service in the `mk8s-worker` node.

---

### Solution 🔥

SSH into worker node:

```
student@kube4sure:~$ ssh mk8s-worker
```

Check the status of the Kubelet service in the `mk8s-worker` node:

```
student@mk8s-worker:~$ systemctl status kubelet
```

Ensuring that any changes are made permanent means starting the Kubelet service automatically after rebooting the node.

Switch to root user:

```
student@mk8s-worker:~$ sudo -i
```

Enable and restart the Kubelet service automatically:

```
student@mk8s-worker:~# systemctl enable --now kubelet
student@mk8s-worker:~# systemctl restart kubelet
```

---

### Explanation & Correctness Check

| Step | Command | Verdict |
|---|---|---|
| SSH into node | `ssh mk8s-worker` | ✅ Correct |
| Diagnose | `systemctl status kubelet` | ✅ Correct starting point |
| Elevate privileges | `sudo -i` | ✅ Correct — needed for systemd changes |
| Enable + start kubelet | `systemctl enable --now kubelet` | ✅ Correct and sufficient on its own |
| Restart kubelet (extra line) | `systemctl restart kubelet` | ⚠️ **Redundant** — not wrong, just unnecessary |

**Details:**

- **`ssh mk8s-worker`** — correct first step, matches the question context.
- **`systemctl status kubelet`** — correct diagnostic step. In the real exam, this is where you'd actually read the output to find *why* the node is `NotReady`. Typical causes: kubelet service stopped, kubelet disabled at boot, misconfiguration in `/var/lib/kubelet/config.yaml` or `/etc/systemd/system/kubelet.service.d/10-kubeadm.conf`, or the container runtime (containerd/CRI-O) not running. The solution assumes "kubelet is stopped/disabled," which is the most common exam scenario — but the real fix always depends on what the status output actually shows. If the cause isn't obvious, also check `journalctl -xeu kubelet` for error details.
- **`sudo -i`** — correct; managing systemd services requires root.
- **`systemctl enable --now kubelet`** — ✅ this line alone is actually **sufficient**. The `--now` flag both **enables** kubelet (so it auto-starts on boot — satisfying "make changes permanent") **and starts it immediately**, in one command.
- **`systemctl restart kubelet`** — ⚠️ **this line is redundant.** Since `enable --now` already starts the service, restarting it again immediately afterward does nothing extra — kubelet was just started. It's not harmful, but it's an unneeded step. (`systemctl restart` would only make sense as an *alternative* fix — e.g., if kubelet was already enabled but hung or crashed and just needed a restart, with no re-enabling required.)

**Suggested corrected/tightened solution:**

```
student@mk8s-worker:~# systemctl enable --now kubelet
```

This single line satisfies both requirements — bringing the node back to `Ready` immediately, and making the fix persist across reboots. The extra `restart` line can be dropped.
