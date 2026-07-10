# Miscellaneous
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
The solution is correct, with one small note about the hint:

namespace: fubar, empty podSelector: {} — correctly targets all pods in fubar, and an empty selector is required since the policy must apply namespace-wide (not to a specific labeled pod).
policyTypes: [Ingress] — correct, since only inbound traffic needs restricting.
ports: [{protocol: TCP, port: 9000}] — correctly scopes the allow rule to port 9000 only. This is what satisfies "does not allow access to Pods which don't listen on port 9000" — traffic to any other port from any source is not permitted by this rule (and since Ingress is listed as the only policyType, all other ingress traffic to fubar pods is now denied by default, which is the intended lock-down).
namespaceSelector.matchLabels: kubernetes.io/metadata.name: internal — this correctly restricts the "from" side to only pods in the internal namespace, satisfying "does not allow access from Pods which are not in namespace internal".

One inconsistency to flag: The Hint says "we need to set a label for the namespace first", implying a manual kubectl label namespace internal <key>=<value> step. But the actual solution uses the automatic, built-in immutable label kubernetes.io/metadata.name, which Kubernetes (v1.21+) applies to every namespace automatically — matching it to the namespace's own name (internal). So no manual labeling step is actually required for this solution to work, despite what the hint suggests. This is only valid on clusters where that automatic label exists (Kubernetes 1.21 or later); on older clusters you'd need to manually label the internal namespace instead.

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