```text
oot@controlplane:~$ ps -aux | grep kubelet
root        1581  2.0  3.0 1896308 71216 ?       Ssl  14:22   0:40 /usr/bin/kubelet --bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf --config=/var/lib/kubelet/config.yaml --container-runtime-endpoint unix:///run/containerd/containerd.sock --cgroup-driver=systemd --eviction-hard imagefs.available<5%,memory.available<100Mi,nodefs.available<5% --fail-swap-on=false
root        1866  3.5 13.1 1516124 303604 ?      Ssl  14:22   1:08 kube-apiserver --advertise-address=172.30.1.2 --allow-privileged=true --authorization-mode=Node,RBAC --client-ca-file=/etc/kubernetes/pki/ca.crt --enable-admission-plugins=NodeRestriction --enable-bootstrap-token-auth=true --etcd-cafile=/etc/kubernetes/pki/etcd/ca.crt --etcd-certfile=/etc/kubernetes/pki/apiserver-etcd-client.crt --etcd-keyfile=/etc/kubernetes/pki/apiserver-etcd-client.key --etcd-servers=https://127.0.0.1:2379 --kubelet-client-certificate=/etc/kubernetes/pki/apiserver-kubelet-client.crt --kubelet-client-key=/etc/kubernetes/pki/apiserver-kubelet-client.key --kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname --proxy-client-cert-file=/etc/kubernetes/pki/front-proxy-client.crt --proxy-client-key-file=/etc/kubernetes/pki/front-proxy-client.key --requestheader-allowed-names=front-proxy-client --requestheader-client-ca-file=/etc/kubernetes/pki/front-proxy-ca.crt --requestheader-extra-headers-prefix=X-Remote-Extra- --requestheader-group-headers=X-Remote-Group --requestheader-username-headers=X-Remote-User --secure-port=6443 --service-account-issuer=https://kubernetes.default.svc.cluster.local --service-account-key-file=/etc/kubernetes/pki/sa.pub --service-account-signing-key-file=/etc/kubernetes/pki/sa.key --service-cluster-ip-range=10.96.0.0/12 --tls-cert-file=/etc/kubernetes/pki/apiserver.crt --tls-private-key-file=/etc/kubernetes/pki/apiserver.key
root        4237  0.0  0.0   3528  1880 pts/0    S+   14:54   0:00 grep --color=auto kubelet
root@controlplane:~$ ps -ef | grep -E "PID|kubelet"
UID          PID    PPID  C STIME TTY          TIME CMD
root        1581       1  2 14:22 ?        00:00:40 /usr/bin/kubelet --bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf --config=/var/lib/kubelet/config.yaml --container-runtime-endpoint unix:///run/containerd/containerd.sock --cgroup-driver=systemd --eviction-hard imagefs.available<5%,memory.available<100Mi,nodefs.available<5% --fail-swap-on=false
root        1866    1653  3 14:22 ?        00:01:08 kube-apiserver --advertise-address=172.30.1.2 --allow-privileged=true --authorization-mode=Node,RBAC --client-ca-file=/etc/kubernetes/pki/ca.crt --enable-admission-plugins=NodeRestriction --enable-bootstrap-token-auth=true --etcd-cafile=/etc/kubernetes/pki/etcd/ca.crt --etcd-certfile=/etc/kubernetes/pki/apiserver-etcd-client.crt --etcd-
● kubelet.service - kubelet: The Kubernetes Node Agent
     Loaded: loaded (/usr/lib/systemd/system/kubelet.service; enabled; preset: enabled)
    Drop-In: /usr/lib/systemd/system/kubelet.service.d
             └─10-kubeadm.conf
     Active: active (running) since Fri 2026-05-08 14:22:48 UTC; 32min ago
       Docs: https://kubernetes.io/docs/
   Main PID: 1581 (kubelet)
      Tasks: 11 (limit: 2649)
     Memory: 69.3M (peak: 69.9M)
        CPU: 40.437s
     CGroup: /system.slice/kubelet.service
             └─1581 /usr/bin/kubelet --bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf --config=/var/lib/kubelet/config.yaml --container-runtime-endpoint unix:///run/containerd>

May 08 14:23:12 controlplane kubelet[1581]: I0508 14:23:12.267934    1581 kuberuntime_manager.go:2062] "Updating runtime config through cri with podcidr" CIDR="192.168.0.0/24"
May 08 14:23:12 controlplane kubelet[1581]: I0508 14:23:12.271100    1581 kubelet_network.go:47] "Updating Pod CIDR" originalPodCIDR="" newPodCIDR="192.168.0.0/24"
May 08 14:23:19 controlplane kubelet[1581]: W0508 14:23:19.379894    1581 manager.go:1172] Failed to process watch event {EventType:0 Name:/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod0e390b72_d075_444a_8b6f_5028>
May 08 14:23:22 controlplane kubelet[1581]: W0508 14:23:22.574830    1581 manager.go:1172] Failed to process watch event {EventType:0 Name:/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod0e390b72_d075_444a_8b6f_5028>
May 08 14:23:26 controlplane kubelet[1581]: W0508 14:23:26.676163    1581 manager.go:1172] Failed to process watch event {EventType:0 Name:/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod0e390b72_d075_444a_8b6f_5028>
May 08 14:23:27 controlplane kubelet[1581]: I0508 14:23:27.095050    1581 scope.go:122] "RemoveContainer" containerID="9b486ca2e81321deda3bacfd82cab2ffe1261c6256f595b457a9e999ddf6a451"
May 08 14:23:27 controlplane kubelet[1581]: I0508 14:23:27.101900    1581 kubelet_resources.go:64] "Allocatable" allocatable={"cpu":"1","ephemeral-storage":"18698430040","hugepages-2Mi":"0","memory":"2197748Ki","pods":"110"}
May 08 14:23:29 controlplane kubelet[1581]: W0508 14:23:29.821663    1581 manager.go:1172] Failed to process watch event {EventType:0 Name:/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod0e390b72_d075_444a_8b6f_5028>
May 08 14:23:32 controlplane kubelet[1581]: W0508 14:23:32.940746    1581 manager.go:1172] Failed to process watch event {EventType:0 Name:/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod0e390b72_d075_444a_8b6f_5028>
May 08 14:23:36 controlplane kubelet[1581]: W0508 14:23:36.088344    1581 manager.go:1172] Failed to process watch event {EventType:0 Name:/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod0e390b72_d075_444a_8b6f_5028
```

# Kubernetes Kubelet & Pod Management Summary

## Kubelet Service Verification
* **Status:** **Active (Running)**. The service has been running since Fri 2026-05-08 14:22:48 UTC.
* **Execution Mode:** **Native Systemd Service**. It is managed as a host service (`kubelet.service`), not as a Pod.
* **Process ID (PID):** **1581**.
* **User:** **root**.

## Pod & Container Management Logic
* **Container Creation:** The **kubelet** is responsible for creating containers. While the *scheduler* selects the node, the *kubelet* on that node talks to the container runtime (CRI) to pull images and start the processes.
* **etcd Communication:** **No**. The kubelet never talks to etcd directly. It only communicates with the **kube-apiserver**, which acts as the sole gatekeeper for etcd.

## Architecture Rule
In Kubernetes, only the **API Server** is permitted to read or write to **etcd**. Every other component (kubelet, scheduler, controller-manager) must go through the API Server.