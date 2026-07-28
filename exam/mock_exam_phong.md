# Practice Experience
Cau an diem: 2,6,8,9
Cac cau lam tiep: 11-16
1. Phai the `storageClassname: ""` thi PV va PVC moi tim duoc nhau do co san default Storage Class
2. Quen `helm repo update`. `--set crds.install=false`
3. Dung initContainer thi gap loi file ko ton tai -> Dung container thu 2 hoac touch file trong initiContainer
If you want deterministic behavior, create the file before running tail:

touch /var/log/apache-web.log
exec tail -f /var/log/apache-web.log

or use tail -F, which is more tolerant:

tail -F /var/log/apache-web.log
4. CPU "2" co nghia la 2Gi 1Gi = 1000m, Ki, Mi, Gi
In the exam, the question states: "You don't have to adjust resources limit - which makes me very confused. Because there were orignally only 2/3 Pods running due to lack of resources, if I don't adjust the resources limit, how can the deployment make 3/3 Pods run?
The wording of this question is intentionally a little misleading. The important distinction is between requests (used by the scheduler) and limits (used at runtime).

Why "don't adjust resource limits" is confusing

If initially only 2/5 or 3/5 Pods were running because of insufficient resources, the scheduler was almost certainly rejecting the remaining Pods based on their resource requests, not their limits.

Kubernetes scheduling works like this:

Requests determine whether a Pod can be placed on a node.
Limits do not affect scheduling (except that they are often set equal to requests).

So if a Pod requests 500m CPU and you have a 1-core node:

2 Pods × 500m = 1000m

The scheduler cannot place a third Pod, even if the Pods are idle.

Therefore, the fix is to reduce the requests. If the question says "configure identical resource requests and limits", you simply set both to the new value.

How to solve
1. Scale to zero
kubectl scale deployment blog-app -n eager-fox --replicas=0
2. Check allocatable resources
kubectl describe node node01

Example:

Allocatable:
cpu:      1
memory:   1846516Ki
3. Divide by 5 Pods

CPU:

1000m / 5 = 200m

Memory:

1846516Ki / 5 ≈ 369303Ki

However, the question says:

Leave enough overhead so the node remains stable.

So don't use the full allocatable resources.

A reasonable exam answer is something like

requests:
  cpu: 180m
  memory: 320Mi

limits:
  cpu: 180m
  memory: 320Mi

or any value that gives all five Pods room while leaving some unused capacity.

4. Configure both containers identically

Both the init container and the main container should have exactly the same resources.

Example:

resources:
  requests:
    cpu: 180m
    memory: 320Mi
  limits:
    cpu: 180m
    memory: 320Mi

Apply this to

init-db
blog-app
5. Scale back
kubectl scale deployment blog-app -n eager-fox --replicas=5

Verify:

kubectl get pods -n eager-fox

All five should become Running.

Why the instruction says "don't adjust limits"

This is where many candidates get confused.

Suppose the original Deployment looked like

resources:
  requests:
    cpu: 500m
    memory: 512Mi
  limits:
    cpu: 500m
    memory: 512Mi

Only two Pods fit on a 1-core node.

Changing them to

resources:
  requests:
    cpu: 180m
    memory: 320Mi
  limits:
    cpu: 180m
    memory: 320Mi

does adjust the limits, but it also adjusts the requests. The important part is that you are not tuning limits independently—you keep requests and limits identical, exactly as the task asks.

If the exam literally said "You don't have to adjust resource limits", it likely meant you don't need to optimize or calculate limits separately. Calculate one fair value, then set both requests and limits to that value for both containers.

So the Pods become schedulable because their requests are smaller. The limits matching those requests is simply part of the required configuration.

5. Phai nho `kubectl explain hpa.spec` de biet `behavior` nam duoi `spec`
6. Xong
7. Quen lay 900000 tru di mot
Phai k rollout restart deploy <name>
8. Done. Doc lai
9. Lam lai, Phai thuoc `/etc/sysctl.d/k8s.conf`
Enable and start it:

sudo systemctl enable cri-docker
sudo systemctl start cri-docker

Verify:

systemctl status cri-docker

You should see:

Active: active (running)
10. Doc sot `A GatewayClass named nginx-gw is already installed.`. Kiem tra bang lenh `kubectl describe httproute api-route, kubectl describe gateway api-gateway`
11. `curl NODEIP:NODEPORT/ping`
```cmd
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: echo-ing
  namespace: echo-lab
spec:
  ingressClassName: nginx-example
  rules:
  - host: "echo.example.local"
    http:
      paths:
      - path: /ping
        pathType: Prefix
        backend:
          service:
            name: echo-svc
            port:
              number: 9090
```
12. Nho cach `curl url `: 
```cmd
    controlplane ~ ✖ k get svc -A
    NAMESPACE     NAME               TYPE           CLUSTER-IP     EXTERNAL-IP      PORT(S)                      AGE
    api-tier      api-tier-service   ClusterIP      10.43.6.183    <none>           8080/TCP                     11m
    default       kubernetes         ClusterIP      10.43.0.1      <none>           443/TCP                      31m
    kube-system   kube-dns           ClusterIP      10.43.0.10     <none>           53/UDP,53/TCP,9153/TCP       30m
    kube-system   metrics-server     ClusterIP      10.43.12.240   <none>           443/TCP                      30m
    kube-system   traefik            LoadBalancer   10.43.196.26   10.244.147.162   80:32165/TCP,443:31640/TCP   30m

controlplane ~ ➜  k exec -n web-tier deploy/web-tier -- curl -s --max-time 5 api-tier-service.api-tier.svc.cluster.local:8080
api-tier
```
13. Done
14. Lam lai
15. Done. Type NodePort va Clusterip khac gi nhau. `kubectl get endpoints web-front-svc -n svc-lab`
16. Done. Chu y append >, >> `echo "${SERVICE_IP} tls-check.k8s.local" >> /etc/hosts`




```cmd 
   touch /var/log/apache-web.log
   tail -f /var/log/apache-web.log
```
4. 
# Ex 1 Reattach an Orphaned PersistentVolume
```cmd 
k get pv -A # Doc Persistent Volume
k describe pv <pv-name>
k edit pv existing-pv # Remove claimRef
k patch pv redis-pv --type=merge -p '{"spec": "{claimRef: null}' # or patch 
vi redis.yaml

k get pv -A
# Check pv status, claimRef, storage class
vi q1.yaml
# Create pvc
# Lam sao nho duoc provisioner: rancher.io/local-path
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: my-storage
provisioner: rancher.io/local-path
reclaimPolicy: Delete
volumeBindingMode: WaitForFirstConsumer

```

# Ex 2 Argo CD via Helm Template Without CRDs
```cmd 
helm repo add argo-helm https://argoproj.github.io/argo-helm
helm repo update
k create ns gitops-ns
helm search repo argo
helm template argocd argo-helm/argo-cd --version=7.9.0 -n gitops-ns --set crds.install=false > /root/argocd-template.yaml

```

# Ex 3 Sidecar Container Sharing a Log Volume
```cmd 
k edit deployment ...
k rollout status deployment apache-web
k logs deploy/apache-web -c log-shipper --tail=5 # thấy log stream từ container chính
```

# Ex. 4  Fair Resource Allocation Across Pods

```cmd 
# Keywords: Limit ranges
kubectl scale --replicas=0 blog-app #1
k edit deploy blog-app #2 Edit resources.limit
k get node
k describe node node01 | grep -A5 Allo
echo $((1846520 * 80 / 100 / 5))
# Use K8s docs to edit Pod template in Deploy

```
# CKA 2026 - Ex 8: Install a CNI That Enforces Network Policy

## Goal
Install a Kubernetes CNI plugin using manifest only.

## Requirements

- Pods communicate across nodes
- Support Kubernetes NetworkPolicy enforcement
- No Helm installation

## Choices

- Flannel v0.27.0
- or Calico v3.29.1

## Step 1 - Choose the correct CNI

### Flannel

**Provides:**
- Pod overlay networking

**Missing:**
- NetworkPolicy enforcement

### Calico

**Provides:**
- Pod networking
- Cross-node communication
- NetworkPolicy enforcement

**Correct answer:** Choose Calico

### Why Calico instead of Flannel

NetworkPolicy requires a CNI that understands and enforces policy rules.

**Flannel:**
```
Pod A ---- Pod B
Networking OK
But:
NetworkPolicy
     |
     X
No enforcement
```

**Calico:**
```
Pod Networking
     +
Policy Engine
NetworkPolicy works
```

## Step 2 - Install Tigera Operator

**Install using manifest:**
```bash
kubectl create -f \
https://raw.githubusercontent.com/projectcalico/calico/v3.29.1/manifests/tigera-operator.yaml
```

**Important:**
- Use: `kubectl create`
- Avoid: `kubectl apply`

**Reason:**
Large CRDs may exceed `kubectl.kubernetes.io/last-applied-configuration` annotation size limit.

**At this point:**

**Installed:**
- Tigera Operator
- CRDs

**Not yet:**
- Calico networking

## Step 3 - Check Kubernetes Pod CIDR

**Command:**
```bash
kubectl cluster-info dump | grep -m 1 cluster-cidr
```

**Example:**
```
--cluster-cidr=10.244.0.0/16
```

**Why important?**

- Calico default: `192.168.0.0/16`
- Cluster may use: `10.244.0.0/16`
- Mismatch causes:
  - Wrong Pod IP range
  - Cross-node networking failure

## Step 4 - Configure custom-resources.yaml

**Download:**
```bash
curl -O \
https://raw.githubusercontent.com/projectcalico/calico/v3.29.1/manifests/custom-resources.yaml
```

**Edit CIDR if needed:**
```yaml
spec:
  calicoNetwork:
    ipPools:
      - name: default-ipv4-ippool
        blockSize: 26
        cidr: 10.244.0.0/16
        encapsulation: VXLANCrossSubnet
```

**Rule:**
```
Calico CIDR = Kubernetes Pod CIDR
```

## Step 5 - Start Calico networking

**Apply:**
```bash
kubectl apply -f custom-resources.yaml
```

**Or default:**
```bash
kubectl apply -f \
https://raw.githubusercontent.com/projectcalico/calico/v3.29.1/manifests/custom-resources.yaml
```

**This creates:**
- calico-node DaemonSet
- calico-kube-controllers
- calico-system namespace

Now CNI is active.

## Verify Tigera Operator

**Command:**
```bash
kubectl get all -n tigera-operator
```

**Expected:**
```
tigera-operator
STATUS: Running
```

## Verify Calico Components

**Command:**
```bash
kubectl get pods -n calico-system
```

**Expected:**
```
calico-node
Running
calico-kube-controllers
Running
```

## Verify Cluster Status

**Check Calico:**
```bash
kubectl get tigerastatus
```

**Expected:**
```
AVAILABLE=True
```

**Check nodes:**
```bash
kubectl get nodes
```

**Expected:**
```
STATUS Ready
```

**Quick check:**
```bash
kubectl get pods -A | grep -Ei 'calico|tigera'
```

## Common CKA Mistakes

### Mistake 1
**Choose Flannel**
- Problem: Network works but NetworkPolicy ignored

### Mistake 2
**Only install tigera-operator.yaml**
- Problem: Operator exists but Calico is not deployed

### Mistake 3
**Forget Pod CIDR check**
- Result: Node Ready, Pod Running, Network broken

### Mistake 4
**Use Helm**
- Wrong: Requirement says Manifest only

## Memory Flow

```
Read requirement
     ↓
Need NetworkPolicy
     ↓
Choose Calico
     ↓
Install Tigera Operator
     ↓
Check Pod CIDR
     ↓
Apply custom-resources.yaml
     ↓
Verify calico-node
     ↓
NetworkPolicy Ready
```


# CKA 2026 - Ex 9: Configure containerd and Kernel Parameters

## Goal
Prepare a Kubernetes node so it can join a cluster.

## Configure

- containerd runtime
- runc package
- Linux kernel networking parameters

This is a common CKA node preparation task.

## Exam Tasks

1. Install package: `~/runc.deb` using dpkg
2. Enable and start: containerd
3. Configure:
   - net.bridge.bridge-nf-call-iptables=1
   - net.bridge.bridge-nf-call-ip6tables=1
   - net.ipv4.ip_forward=1
   - net.netfilter.nf_conntrack_max=262144

## Step 1 - Install runc package

**Command:**
```bash
sudo dpkg -i ~/runc.deb
```

**Meaning:**
runc is the low-level OCI runtime.

```
containerd
     |
     v
    runc
     |
     v
Linux container process
```

## Step 2 - Enable containerd service

**Command:**
```bash
sudo systemctl enable --now containerd
```

**Equivalent to:**
```bash
systemctl enable containerd
systemctl start containerd
```

**Benefit:**
- Start immediately
- Automatically start after reboot

## Step 3 - Create persistent sysctl config

**Create:** `/etc/sysctl.d/k8s.conf`

**Command:**
```bash
sudo tee /etc/sysctl.d/k8s.conf >/dev/null <<EOF
net.bridge.bridge-nf-call-iptables=1
net.bridge.bridge-nf-call-ip6tables=1
net.ipv4.ip_forward=1
net.netfilter.nf_conntrack_max=262144
EOF
```

## Step 4 - Apply kernel configuration

**Command:**
```bash
sudo sysctl --system
```

**Why not only:** `sysctl -w`?

**Because:**
```
sysctl -w
     |
     v
Runtime only
After reboot: configuration lost
```

**Correct:**
```
/etc/sysctl.d/k8s.conf
     |
     v
Persistent configuration
```

## Why Kubernetes needs these parameters

**bridge-nf-call-iptables:**
Allows packets crossing Linux bridge to be processed by iptables.
Required for:
- kube-proxy
- Service routing
- NetworkPolicy

**ip_forward:**
Allows node to forward packets.
Required for:
- Pod -> Node -> Pod communication

**nf_conntrack_max:**
Controls connection tracking table size.
Used by:
- NAT
- Services
- Large traffic clusters

## Verify containerd

**Command:**
```bash
sudo systemctl status containerd
```

**Expected:**
```
active (running)
```

## Verify Kernel Parameters

**Command:**
```bash
sysctl \
  net.bridge.bridge-nf-call-iptables \
  net.bridge.bridge-nf-call-ip6tables \
  net.ipv4.ip_forward \
  net.netfilter.nf_conntrack_max
```

**Expected:**
```
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
net.netfilter.nf_conntrack_max = 262144
```

## Common CKA Mistakes

### Mistake 1
**Only start containerd**
- Forgot: `systemctl enable`
- After reboot: containerd stopped

### Mistake 2
**Use only sysctl -w**
- After reboot: settings disappear

### Mistake 3
**Forget ip_forward**
- Symptoms: Node Ready, Pods Running, Network broken

## Memory Flow

```
Install runc
     ↓
Enable containerd
     ↓
Create: /etc/sysctl.d/k8s.conf
     ↓
Run: sysctl --system
     ↓
Verify service + kernel
     ↓
Node ready for Kubernetes
```

# Ex 10: Migrate Ingress to Gateway API
https://gateway-api.sigs.k8s.io/guides/getting-started/migrating-from-ingress/ 
## Goal
Migrate existing api-ingress to Kubernetes Gateway API.

## Keep

- HTTPS configuration
- TLS Secret
- Hostname
- Routing rules
- Backend Service

**Existing:**
- GatewayClass: nginx-gw

**Create:**
- Gateway: api-gateway
- HTTPRoute: api-route
- Hostname: api.gateway.local

## Architecture

**Before:**
```
Client
   |
 HTTPS
   |
Ingress api-ingress
   |
Service api-service:80
   |
  Pod
```

**After:**
```
Client
   |
 HTTPS
   |
Gateway api-gateway
   |
HTTPRoute api-route
   |
Service api-service:80
   |
  Pod
```

## Step 1 - Inspect existing Ingress

```bash
kubectl describe ingress api-ingress
```

**Collect:**
- Host: api.gateway.local
- TLS Secret: api-tls
- Backend: api-service:80
- Path: / (Prefix)

**Reason:**
Gateway API does not automatically migrate Ingress. You must manually copy host, TLS and backend config.

## Step 2 - Create Gateway gw.yaml

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: api-gateway
spec:
  gatewayClassName: nginx-gw
  listeners:
    - name: https
      protocol: HTTPS
      port: 443
      hostname: api.gateway.local
      tls:
        mode: Terminate
        certificateRefs:
          - kind: Secret
            name: api-tls
```

**Apply:**
```bash
kubectl apply -f gw.yaml
```

**Gateway responsibility:**
- Listener
- HTTPS Port 443
- TLS termination
- Certificate handling

## Step 3 - Create HTTPRoute http.yaml

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: api-route
spec:
  parentRefs:
    - name: api-gateway
  hostnames:
    - api.gateway.local
  rules:
    - matches:
        - path:
            type: PathPrefix
            value: /
      backendRefs:
        - name: api-service
          port: 80
```

**Apply:**
```bash
kubectl apply -f http.yaml
```

**Important:**
parentRefs attaches HTTPRoute to Gateway.
Without parentRefs:
- Gateway Created OK
- HTTPRoute Created OK
- Traffic FAIL

## Ingress to Gateway Mapping

```
Ingress spec.tls.secretName         -> Gateway listener tls.certificateRefs
Ingress rules.host                  -> HTTPRoute hostnames
Ingress path rules                  -> HTTPRoute matches
Ingress backend.service             -> HTTPRoute backendRefs
```

## Verification

**Check Gateway:**
```bash
kubectl describe gateway api-gateway
```

**Expected:**
```
Listener:
- HTTPS
- Port 443
- Host api.gateway.local
- Certificate api-tls
```

**Check HTTPRoute:**
```bash
kubectl describe httproute api-route
```

**Expected:**
```
Parent: api-gateway
Host: api.gateway.local
Rule: / -> api-service:80
```

## Common CKA Mistakes

1. **Create Gateway only**
   - Result: Listener ready but no traffic

2. **Forget parentRefs**
   - HTTPRoute not attached

3. **Forget certificateRefs**
   - HTTPS fails

4. **Host mismatch**
   - Gateway: api.gateway.local
   - HTTPRoute: different host
   - Traffic does not match

## Memory Flow

```
Read Ingress
     ↓
Copy:
- Host
- TLS Secret
- Backend
     ↓
Create Gateway
     ↓
Create HTTPRoute
     ↓
Attach parentRefs
     ↓
Verify HTTPS routing
```

# Ex 11: Expose a Deployment via NodePort and Ingress
```cmd
 k expose deployment echo-server -n ns --name=echo-svc --type NodePort --port 9090 --target-pod 9090
 # Describ deployment de tim xem --target-pod bang bao nhieu
```
# Ex 12: Choose the Least-Permissive NetworkPolicy
```cmd 
k get networkpolicy -n api-tier k exec -n web-tier deploy/web-tier -- \ curl -s --max-time 5 api-tier-service.api-tier.svc.cluster.local:8080
```
## Goal
Select the safest NetworkPolicy.

**Allow:**
```
web-tier
     |
     v
api-tier
```
**Only:** TCP port 8080

Apply the policy with least privilege.

## Exam Scenario

**Existing workloads:**
- Deployment: web-tier
  - Namespace: web-tier
- Deployment: api-tier
  - Namespace: api-tier

**Policy candidates:**
- /root/netpols/policy-1.yaml
- /root/netpols/policy-2.yaml
- /root/netpols/policy-3.yaml

**Task:** Review all, Choose the least permissive one

## NetworkPolicy Principle

**Security rule:** Allow only what is required.

**Do NOT allow:**
- All namespaces
- All pods
- Extra IP ranges
- Extra ports

**Goal:** Minimum permission + Application still works

## Step 1 - Review candidate policies

**Commands:**
```bash
cat /root/netpols/policy-1.yaml
cat /root/netpols/policy-2.yaml
cat /root/netpols/policy-3.yaml
```

**Compare:**
- podSelector
- namespaceSelector
- ingress rules
- ports
- ipBlock

### Policy 1 Analysis

**Example:**
```yaml
podSelector: {}
ingress:
  - {}
```

**Meaning:** Allow traffic to ALL pods from ANY source.

**Result:** Too permissive. Reject.

### Policy 2 Analysis

**Example:** Allows namespace: web-tier BUT also ipBlock: 10.0.0.0/8

**Problem:** Extra network access granted.

**Result:** Application works but Not least privilege. Reject.

### Policy 3 Analysis - Correct Choice

**Policy 3:**
- Target: app=api-tier
- Allow from: namespace=web-tier + pod=web-tier
- Only port: TCP 8080

**Result:** Required access only. Choose this policy.

## Traffic Model

**Allowed:**
```
web-tier pod TCP 8080
           |
           v
     api-tier pod
```

**Blocked:**
- Other namespace
- Other pod
- Other port

## Step 2 - Verify labels

**Before applying:** Check labels:
```bash
kubectl get pods -n web-tier --show-labels
```

**Confirm:** app=web-tier

**Reason:** NetworkPolicy depends on labels.

## Step 3 - Apply selected policy

**Command:**
```bash
kubectl apply -f /root/netpols/policy-3.yaml
```

**Only apply:** The least permissive policy

## Verify NetworkPolicy

**Check:**
```bash
kubectl get networkpolicy -n api-tier
```

**Test connection:**
```bash
kubectl exec -n web-tier deploy/web-tier -- \
  curl -s --max-time 5 \
  api-tier-service.api-tier.svc.cluster.local:8080
```

**Expected:** Connection successful

## Common CKA Mistakes

### Mistake 1
**Choose policy that only works**
- Remember: Working != Secure

### Mistake 2
**Ignore podSelector {}**
- Problem: {} usually means ALL

### Mistake 3
**Ignore extra CIDR**
- Example: 10.0.0.0/8

### Mistake 4
**Forget labels**
- NetworkPolicy uses labels, not Deployment names.

## Memory Flow

```
Read all policies
     ↓
Find required traffic
     ↓
web-tier -> api-tier
     ↓
TCP 8080 only
     ↓
Remove extra permissions
     ↓
Apply strictest policy
     ↓
Verify connection
```

# Ex 13
```cmd
k get storageclass local-storage -ojson
k patch storageclass local-storage -p '{}'
k patch storageclass standard -p '{}'
```
# CKA 2026 - Ex 14: Fix Broken kube-apiserver -> etcd Connection

## Goal
Recover Kubernetes Control Plane.

## Problem
After migration: kube-apiserver cannot start.

**Root cause:** `--etcd-servers` points to OLD etcd endpoint.

**Need:**
1. Diagnose API Server failure
2. Find correct etcd endpoint
3. Fix kube-apiserver static pod

## Architecture

```
 kubectl
     |
     v
kube-apiserver
     |
     v
external etcd :2379
```

If etcd endpoint is wrong:
- kube-apiserver cannot start
- kubectl becomes unavailable

## Step 1 - Confirm API Server is down

**Command:**
```bash
kubectl get nodes
```

**Expected:** connection refused or timeout

**Reason:** kubectl needs kube-apiserver.

## Step 2 - Check kube-apiserver container

**Use container runtime:**
```bash
sudo crictl ps -a | grep kube-apiserver
```

**Why:** crictl talks directly to containerd. It does not require Kubernetes API.

**Expected:** kube-apiserver restarting / failed

## Step 3 - Check current wrong etcd endpoint

**Static pod manifest:** `/etc/kubernetes/manifests/kube-apiserver.yaml`

**Command:**
```bash
sudo grep etcd-servers /etc/kubernetes/manifests/kube-apiserver.yaml
```

**Example:**
```
--etcd-servers=https://192.168.1.10:2379
```

This is the configured endpoint. It may be the OLD IP.

### How to find the NEW etcd endpoint - Method 1

Search existing configuration:
```bash
grep -R etcd-servers /etc/kubernetes/
```

**Possible result:** `backup/kube-apiserver.yaml`

**Example:**
```
--etcd-servers=https://192.168.1.20:2379
```

Use this endpoint.

### How to find the NEW etcd endpoint - Method 2: Check etcd certificate SAN

External etcd usually uses TLS. Certificates contain valid etcd addresses.

**Check certificate:**
```bash
openssl x509 -in /etc/kubernetes/pki/apiserver-etcd-client.crt -text -noout
```

**Look for:** Subject Alternative Name

**Example:**
```
IP Address:192.168.1.20
```

**Meaning:** 192.168.1.20 is a valid etcd endpoint.

Then configure: `--etcd-servers=https://192.168.1.20:2379`

### How to find the NEW etcd endpoint - Method 3: Check etcd node

Login to the etcd node.

**Check etcd process:**
```bash
systemctl status etcd
```

or:
```bash
ps aux | grep etcd
```

**Look for:** `--listen-client-urls`

**Example:**
```
--listen-client-urls=https://192.168.1.20:2379
```

This is the address where etcd accepts client connections. kube-apiserver must use this endpoint.

## Step 4 - Fix kube-apiserver manifest

**Edit:**
```bash
sudo vi /etc/kubernetes/manifests/kube-apiserver.yaml
```

**Change:**
- OLD: `--etcd-servers=https://192.168.1.10:2379`
- NEW: `--etcd-servers=https://192.168.1.20:2379`

Save file.

**Why no kubectl apply?**
kube-apiserver is Static Pod. Managed by kubelet.

kubelet watches: `/etc/kubernetes/manifests/`

```
File changed
     |
     v
kubelet recreates kube-apiserver automatically
```

## Step 5 - Wait and Verify

**Wait:**
```bash
sleep 60
```

**Verify:**
```bash
kubectl get nodes
```

**Expected:** Nodes displayed

**Check:**
```bash
kubectl -n kube-system get pods | grep kube-apiserver
```

**Expected:** Running

## Common CKA Mistakes

### Mistake 1
**Trying kubectl troubleshooting**
- Wrong because: API Server is down.

### Mistake 2
**Guess new etcd IP**
- Correct: Find endpoint from:
  - backup config
  - certificate SAN
  - etcd process

### Mistake 3
**Restart wrong component**
- Static pod is handled by kubelet.

## Memory Flow

```
kubectl fails
     ↓
Use crictl
     ↓
Check kube-apiserver.yaml
     ↓
Find real etcd endpoint:
- backup
- certificate SAN
- etcd process
     ↓
Fix --etcd-servers
     ↓
kubelet restarts static pod
     ↓
Control Plane recovered
```

# Ex 15
k expose deploy web-front -n svc-lab --containerPort=3000 --type=NodePort

    containerPort: 3000