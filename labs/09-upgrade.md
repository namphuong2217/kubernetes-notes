# OS Upgrades
```cmd
             Welcome to the KodeKloud Hands-On lab                                                                                                                                                        
    __ ______  ____  ________ __ __    ____  __  ______ 
   / //_/ __ \/ __ \/ ____/ //_// /   / __ \/ / / / __ \
  / ,< / / / / / / / __/ / ,<  / /   / / / / / / / / / /
 / /| / /_/ / /_/ / /___/ /| |/ /___/ /_/ / /_/ / /_/ / 
/_/ |_\____/_____/_____/_/ |_/_____/\____/\____/_____/  
                                                        
                     All rights reserved                                                                                                                                                                  

controlplane ~ ➜  #1

controlplane ~ ➜  k get nodes -A
NAME           STATUS   ROLES           AGE     VERSION
controlplane   Ready    control-plane   10m     v1.35.0
node01         Ready    <none>          9m34s   v1.35.0

controlplane ~ ➜  #2

controlplane ~ ➜  k get deploy 
NAME   READY   UP-TO-DATE   AVAILABLE   AGE
blue   3/3     3            3           12s

controlplane ~ ➜  #4

controlplane ~ ➜  k get deploy -o wide
NAME   READY   UP-TO-DATE   AVAILABLE   AGE   CONTAINERS   IMAGES         SELECTOR
blue   3/3     3            3           33s   nginx        nginx:alpine   app=blue

controlplane ~ ➜  k describe deploy blue
Name:                   blue
Namespace:              default
CreationTimestamp:      Wed, 10 Jun 2026 12:29:52 +0000
Labels:                 app=blue
Annotations:            deployment.kubernetes.io/revision: 1
Selector:               app=blue
Replicas:               3 desired | 3 updated | 3 total | 3 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  app=blue
  Containers:
   nginx:
    Image:         nginx:alpine
    Port:          80/TCP
    Host Port:     0/TCP
    Environment:   <none>
    Mounts:        <none>
  Volumes:         <none>
  Node-Selectors:  <none>
  Tolerations:     <none>
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      True    MinimumReplicasAvailable
  Progressing    True    NewReplicaSetAvailable
OldReplicaSets:  <none>
NewReplicaSet:   blue-6466bf85df (3/3 replicas created)
Events:
  Type    Reason             Age   From                   Message
  ----    ------             ----  ----                   -------
  Normal  ScalingReplicaSet  48s   deployment-controller  Scaled up replica set blue-6466bf85df from 0 to 3

controlplane ~ ➜  k get pod -l app=blue
NAME                    READY   STATUS    RESTARTS   AGE
blue-6466bf85df-bmw62   1/1     Running   0          103s
blue-6466bf85df-pz4q9   1/1     Running   0          103s
blue-6466bf85df-x85mz   1/1     Running   0          103s

controlplane ~ ➜  k get pod -l app=blue -o wide
NAME                    READY   STATUS    RESTARTS   AGE    IP           NODE           NOMINATED NODE   READINESS GATES
blue-6466bf85df-bmw62   1/1     Running   0          107s   172.17.1.2   node01         <none>           <none>
blue-6466bf85df-pz4q9   1/1     Running   0          107s   172.17.1.3   node01         <none>           <none>
blue-6466bf85df-x85mz   1/1     Running   0          107s   172.17.0.4   controlplane   <none>           <none>

controlplane ~ ➜  #4

controlplane ~ ➜  k cordon node01 
node/node01 cordoned

controlplane ~ ➜  k drain node01 
node/node01 already cordoned
error: unable to drain node "node01" due to error: cannot delete DaemonSet-managed Pods (use --ignore-daemonsets to ignore): kube-flannel/kube-flannel-ds-hwgpm, kube-system/kube-proxy-glnds, continuing command...
There are pending nodes to be drained:
 node01
cannot delete DaemonSet-managed Pods (use --ignore-daemonsets to ignore): kube-flannel/kube-flannel-ds-hwgpm, kube-system/kube-proxy-glnds

controlplane ~ ✖ k drain node01 --ignore-daemonsets 
node/node01 already cordoned
Warning: ignoring DaemonSet-managed Pods: kube-flannel/kube-flannel-ds-hwgpm, kube-system/kube-proxy-glnds
evicting pod default/blue-6466bf85df-pz4q9
evicting pod default/blue-6466bf85df-bmw62
pod/blue-6466bf85df-bmw62 evicted
pod/blue-6466bf85df-pz4q9 evicted
node/node01 drained

controlplane ~ ➜  #5

controlplane ~ ➜  k get pod -l app=blue -o wide
NAME                    READY   STATUS    RESTARTS   AGE     IP           NODE           NOMINATED NODE   READINESS GATES
blue-6466bf85df-8kgwv   1/1     Running   0          45s     172.17.0.5   controlplane   <none>           <none>
blue-6466bf85df-f2zzk   1/1     Running   0          45s     172.17.0.6   controlplane   <none>           <none>
blue-6466bf85df-x85mz   1/1     Running   0          3m43s   172.17.0.4   controlplane   <none>           <none>

controlplane ~ ➜  #6

controlplane ~ ➜  k uncordon node01 
node/node01 uncordoned

controlplane ~ ➜  #7

controlplane ~ ➜  k get pod -owide
NAME                    READY   STATUS    RESTARTS   AGE     IP           NODE           NOMINATED NODE   READINESS GATES
blue-6466bf85df-8kgwv   1/1     Running   0          91s     172.17.0.5   controlplane   <none>           <none>
blue-6466bf85df-f2zzk   1/1     Running   0          91s     172.17.0.6   controlplane   <none>           <none>
blue-6466bf85df-x85mz   1/1     Running   0          4m29s   172.17.0.4   controlplane   <none>           <none>

controlplane ~ ➜  #8

controlplane ~ ➜  #9

controlplane ~ ➜  k describe node controlplane 
Name:               controlplane
Roles:              control-plane
Labels:             beta.kubernetes.io/arch=amd64
                    beta.kubernetes.io/os=linux
                    kubernetes.io/arch=amd64
                    kubernetes.io/hostname=controlplane
                    kubernetes.io/os=linux
                    node-role.kubernetes.io/control-plane=
                    node.kubernetes.io/exclude-from-external-load-balancers=
Annotations:        flannel.alpha.coreos.com/backend-data: {"VNI":1,"VtepMAC":"de:84:54:e4:27:51"}
                    flannel.alpha.coreos.com/backend-type: vxlan
                    flannel.alpha.coreos.com/kube-subnet-manager: true
                    flannel.alpha.coreos.com/public-ip: 10.244.253.170
                    node.alpha.kubernetes.io/ttl: 0
                    volumes.kubernetes.io/controller-managed-attach-detach: true
CreationTimestamp:  Wed, 10 Jun 2026 12:19:19 +0000
Taints:             <none>
Unschedulable:      false
Lease:
  HolderIdentity:  controlplane
  AcquireTime:     <unset>
  RenewTime:       Wed, 10 Jun 2026 12:34:41 +0000
Conditions:
  Type                 Status  LastHeartbeatTime                 LastTransitionTime                Reason                       Message
  ----                 ------  -----------------                 ------------------                ------                       -------
  NetworkUnavailable   False   Wed, 10 Jun 2026 12:19:32 +0000   Wed, 10 Jun 2026 12:19:32 +0000   FlannelIsUp                  Flannel is running on this node
  MemoryPressure       False   Wed, 10 Jun 2026 12:31:05 +0000   Wed, 10 Jun 2026 12:19:18 +0000   KubeletHasSufficientMemory   kubelet has sufficient memory available
  DiskPressure         False   Wed, 10 Jun 2026 12:31:05 +0000   Wed, 10 Jun 2026 12:19:18 +0000   KubeletHasNoDiskPressure     kubelet has no disk pressure
  PIDPressure          False   Wed, 10 Jun 2026 12:31:05 +0000   Wed, 10 Jun 2026 12:19:18 +0000   KubeletHasSufficientPID      kubelet has sufficient PID available
  Ready                True    Wed, 10 Jun 2026 12:31:05 +0000   Wed, 10 Jun 2026 12:19:30 +0000   KubeletReady                 kubelet is posting ready status
Addresses:
  InternalIP:  10.244.253.170
  Hostname:    controlplane
Capacity:
  cpu:                16
  ephemeral-storage:  457717264Ki
  hugepages-1Gi:      0
  hugepages-2Mi:      0
  memory:             64932564Ki
  pods:               110
Allocatable:
  cpu:                16
  ephemeral-storage:  421832229804
  hugepages-1Gi:      0
  hugepages-2Mi:      0
  memory:             64830164Ki
  pods:               110
System Info:
  Machine ID:                 8857e26bcf0549a5b7055ed0c10221b6
  System UUID:                b4d38b64-bc94-11ee-9542-07fc1165925c
  Boot ID:                    5b4fbb4b-882a-4687-a2df-d009bbf8843c
  Kernel Version:             6.8.0-90-generic
  OS Image:                   Ubuntu 22.04.5 LTS
  Operating System:           linux
  Architecture:               amd64
  Container Runtime Version:  containerd://1.7.22
  Kubelet Version:            v1.35.0
  Kube-Proxy Version:         
PodCIDR:                      172.17.0.0/24
PodCIDRs:                     172.17.0.0/24
Non-terminated Pods:          (11 in total)
  Namespace                   Name                                    CPU Requests  CPU Limits  Memory Requests  Memory Limits  Age
  ---------                   ----                                    ------------  ----------  ---------------  -------------  ---
  default                     blue-6466bf85df-8kgwv                   0 (0%)        0 (0%)      0 (0%)           0 (0%)         118s
  default                     blue-6466bf85df-f2zzk                   0 (0%)        0 (0%)      0 (0%)           0 (0%)         118s
  default                     blue-6466bf85df-x85mz                   0 (0%)        0 (0%)      0 (0%)           0 (0%)         4m56s
  kube-flannel                kube-flannel-ds-g9d9g                   100m (0%)     0 (0%)      50Mi (0%)        0 (0%)         15m
  kube-system                 coredns-6f6c7df987-86j59                100m (0%)     0 (0%)      70Mi (0%)        170Mi (0%)     15m
  kube-system                 coredns-6f6c7df987-zsjtz                100m (0%)     0 (0%)      70Mi (0%)        170Mi (0%)     15m
  kube-system                 etcd-controlplane                       100m (0%)     0 (0%)      100Mi (0%)       0 (0%)         15m
  kube-system                 kube-apiserver-controlplane             250m (1%)     0 (0%)      0 (0%)           0 (0%)         15m
  kube-system                 kube-controller-manager-controlplane    200m (1%)     0 (0%)      0 (0%)           0 (0%)         15m
  kube-system                 kube-proxy-cfzx6                        0 (0%)        0 (0%)      0 (0%)           0 (0%)         15m
  kube-system                 kube-scheduler-controlplane             100m (0%)     0 (0%)      0 (0%)           0 (0%)         15m
Allocated resources:
  (Total limits may be over 100 percent, i.e., overcommitted.)
  Resource           Requests    Limits
  --------           --------    ------
  cpu                950m (5%)   0 (0%)
  memory             290Mi (0%)  340Mi (0%)
  ephemeral-storage  0 (0%)      0 (0%)
  hugepages-1Gi      0 (0%)      0 (0%)
  hugepages-2Mi      0 (0%)      0 (0%)
Events:
  Type    Reason          Age   From             Message
  ----    ------          ----  ----             -------
  Normal  RegisteredNode  15m   node-controller  Node controlplane event: Registered Node controlplane in Controller

controlplane ~ ➜  #10

controlplane ~ ➜  #11

controlplane ~ ➜  k drain node01 --ignore-daemonsets 
node/node01 cordoned
error: unable to drain node "node01" due to error: cannot delete cannot delete Pods that declare no controller (use --force to override): default/hr-app, continuing command...
There are pending nodes to be drained:
 node01
cannot delete cannot delete Pods that declare no controller (use --force to override): default/hr-app

controlplane ~ ✖ k get pod
NAME                    READY   STATUS    RESTARTS   AGE
blue-6466bf85df-8kgwv   1/1     Running   0          2m56s
blue-6466bf85df-f2zzk   1/1     Running   0          2m56s
blue-6466bf85df-x85mz   1/1     Running   0          5m54s
hr-app                  1/1     Running   0          49s

controlplane ~ ➜  #12 13

controlplane ~ ➜  #14

controlplane ~ ➜  #15

controlplane ~ ➜  #16

controlplane ~ ➜  k cordon node01 
node/node01 cordoned

controlplane ~ ➜  history
    1  #1
    2  k get nodes -A
    3  #2
    4  k get deploy 
    5  #4
    6  k get deploy -o wide
    7  k describe deploy blue
    8  k get pod -l app=blue
    9  k get pod -l app=blue -o wide
   10  #4
   11  k cordon node01 
   12  k drain node01 
   13  k drain node01 --ignore-daemonsets 
   14  #5
   15  k get pod -l app=blue -o wide
   16  #6
   17  k uncordon node01 
   18  #7
   19  k get pod -owide
   20  #8
   21  #9
   22  k describe node controlplane 
   23  #10
   24  #11
   25  k drain node01 --ignore-daemonsets 
   26  k get pod
   27  #12 13
   28  #14
   29  #15
   30  #16
   31  k cordon node01 
   32  history
```

# Upgrade cluster

```cmd 
controlplane ~ ➜  history
    1  #1
    2  k get node
    3  #2
    4  #3
    5  k describe node controlplane | grep -i 'taint' -C5
    6  k describe node node01 | grep -i 'taint' -C5
    7  #4
    8  k get node -o wide
    9  k get deploy -n default
   10  #5
   11  k get pod -o wide
   12  #6
   13  #7
   14  kubeadmin upgrade plan
   15  kubeadm upgrade plan
   16  kubeadm upgrade plan | grep -i 'remote'
   17  #8
   18  k drain node controlplane
   19  k drain controlplane
   20  k drain controlplane --ignore-daemonsets 
   21  #9
   22  echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
   23  echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.35/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
   24  sudo apt update
   25  sudo apt-cache madison kubeadm
   26  sudo apt-mark unhold kubeadm && sudo apt-get update && sudo apt-get install -y kubeadm='1.35.0-1.1' && sudo apt-mark hold kubeadm
   27  sudo kubeadm upgrade plan
   28  sudo kubeadm upgrade apply v1.35.0
   29  k drain node01 
   30  k drain node01 --ignore-daemonsets 
   31  sudo apt-mark unhold kubelet kubectl && sudo apt-get update && sudo apt-get install -y kubelet='1.35.0-1' kubectl='1.35.0-1' && sudo apt-mark hold kubelet kubectl
   32  sudo apt-mark unhold kubelet kubectl && sudo apt-get update && sudo apt-get install -y kubelet='1.35.0-1.1' kubectl='1.35.0-1.1' && sudo apt-mark hold kubelet kubectl
   33  k get node
   34  sudo systemctl daemon-reload
   35  sudo systemctl restart kubelet
   36  k get node
   37  k get nodes
   38  #10
   39  k uncordon controlplane 
   40  #11
   41  k cordon node01 
   42  #12
   43  ssh node01
   44  k get node
   45  history
```

```cmd
       Welcome to the KodeKloud Hands-On lab                                                                                    
    __ ______  ____  ________ __ __    ____  __  ______ 
   / //_/ __ \/ __ \/ ____/ //_// /   / __ \/ / / / __ \
  / ,< / / / / / / / __/ / ,<  / /   / / / / / / / / / /
 / /| / /_/ / /_/ / /___/ /| |/ /___/ /_/ / /_/ / /_/ / 
/_/ |_\____/_____/_____/_/ |_/_____/\____/\____/_____/  
                                                        
             All rights reserved                                                                                                 

controlplane ~ ➜  #1

controlplane ~ ➜  k get node
NAME           STATUS   ROLES           AGE   VERSION
controlplane   Ready    control-plane   27m   v1.34.0
node01         Ready    <none>          26m   v1.34.0

controlplane ~ ➜  #2

controlplane ~ ➜  #3

controlplane ~ ➜  k describe node controlplane | grep -i 'taint' -C5
                    flannel.alpha.coreos.com/kube-subnet-manager: true
                    flannel.alpha.coreos.com/public-ip: 10.244.154.58
                    node.alpha.kubernetes.io/ttl: 0
                    volumes.kubernetes.io/controller-managed-attach-detach: true
CreationTimestamp:  Mon, 08 Jun 2026 13:59:16 +0000
Taints:             <none>
Unschedulable:      false
Lease:
  HolderIdentity:  controlplane
  AcquireTime:     <unset>
  RenewTime:       Mon, 08 Jun 2026 14:27:22 +0000

controlplane ~ ➜  k describe node node01 | grep -i 'taint' -C5
                    flannel.alpha.coreos.com/kube-subnet-manager: true
                    flannel.alpha.coreos.com/public-ip: 10.244.162.134
                    node.alpha.kubernetes.io/ttl: 0
                    volumes.kubernetes.io/controller-managed-attach-detach: true
CreationTimestamp:  Mon, 08 Jun 2026 13:59:46 +0000
Taints:             <none>
Unschedulable:      false
Lease:
  HolderIdentity:  node01
  AcquireTime:     <unset>
  RenewTime:       Mon, 08 Jun 2026 14:27:27 +0000

controlplane ~ ➜  #4

controlplane ~ ➜  k get node -o wide
NAME           STATUS   ROLES           AGE   VERSION   INTERNAL-IP      EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION     CONTAINER-RUNTIME
controlplane   Ready    control-plane   28m   v1.34.0   10.244.154.58    <none>        Ubuntu 22.04.5 LTS   6.8.0-90-generic   containerd://1.6.26
node01         Ready    <none>          28m   v1.34.0   10.244.162.134   <none>        Ubuntu 22.04.5 LTS   6.8.0-90-generic   containerd://1.6.26

controlplane ~ ➜  k get deploy -n default
NAME   READY   UP-TO-DATE   AVAILABLE   AGE
blue   5/5     5            5           2m13s

controlplane ~ ➜  #5

controlplane ~ ➜  k get pod -o wide
NAME                   READY   STATUS    RESTARTS   AGE     IP           NODE           NOMINATED NODE   READINESS GATES
blue-759779556-624pm   1/1     Running   0          2m43s   172.17.0.5   controlplane   <none>           <none>
blue-759779556-fp6kw   1/1     Running   0          2m43s   172.17.1.4   node01         <none>           <none>
blue-759779556-hvtqt   1/1     Running   0          2m43s   172.17.1.2   node01         <none>           <none>
blue-759779556-khhht   1/1     Running   0          2m43s   172.17.0.4   controlplane   <none>           <none>
blue-759779556-mfsbx   1/1     Running   0          2m43s   172.17.1.3   node01         <none>           <none>

controlplane ~ ➜  #6

controlplane ~ ➜  #7

controlplane ~ ➜  kubeadmin upgrade plan
-bash: kubeadmin: command not found

controlplane ~ ✖ kubeadm upgrade plan
[preflight] Running pre-flight checks.
[upgrade/config] Reading configuration from the "kubeadm-config" ConfigMap in namespace "kube-system"...
[upgrade/config] Use 'kubeadm init phase upload-config kubeadm --config your-config-file' to re-upload it.
[upgrade] Running cluster health checks
[upgrade] Fetching available versions to upgrade to
[upgrade/versions] Cluster version: 1.34.0
[upgrade/versions] kubeadm version: v1.34.0
I0608 14:30:58.527871   22926 version.go:260] remote version is much newer: v1.36.1; falling back to: stable-1.34
[upgrade/versions] Target version: v1.34.8
[upgrade/versions] Latest version in the v1.34 series: v1.34.8

Components that must be upgraded manually after you have upgraded the control plane with 'kubeadm upgrade apply':
COMPONENT   NODE           CURRENT   TARGET
kubelet     controlplane   v1.34.0   v1.34.8
kubelet     node01         v1.34.0   v1.34.8

Upgrade to the latest version in the v1.34 series:

COMPONENT                 NODE           CURRENT   TARGET
kube-apiserver            controlplane   v1.34.0   v1.34.8
kube-controller-manager   controlplane   v1.34.0   v1.34.8
kube-scheduler            controlplane   v1.34.0   v1.34.8
kube-proxy                               1.34.0    v1.34.8
CoreDNS                                  v1.10.1   v1.12.1
etcd                      controlplane   3.6.4-0   3.6.4-0

You can now apply the upgrade by executing the following command:

        kubeadm upgrade apply v1.34.8

Note: Before you can perform this upgrade, you have to update kubeadm to v1.34.8.

_____________________________________________________________________


The table below shows the current state of component configs as understood by this version of kubeadm.
Configs that have a "yes" mark in the "MANUAL UPGRADE REQUIRED" column require manual config upgrade or
resetting to kubeadm defaults before a successful upgrade can be performed. The version to manually
upgrade to is denoted in the "PREFERRED VERSION" column.

API GROUP                 CURRENT VERSION   PREFERRED VERSION   MANUAL UPGRADE REQUIRED
kubeproxy.config.k8s.io   v1alpha1          v1alpha1            no
kubelet.config.k8s.io     v1beta1           v1beta1             no
_____________________________________________________________________


controlplane ~ ➜  kubeadm upgrade plan | grep -i 'remote'

I0608 14:32:03.850455   23334 version.go:260] remote version is much newer: v1.36.1; falling back to: stable-1.34

controlplane ~ ✖ 

controlplane ~ ✖ #8

controlplane ~ ✖ k drain node controlplane
Error from server (NotFound): nodes "node" not found

controlplane ~ ✖ k drain controlplane
node/controlplane cordoned
error: unable to drain node "controlplane" due to error: cannot delete DaemonSet-managed Pods (use --ignore-daemonsets to ignore): kube-flannel/kube-flannel-ds-wmv97, kube-system/kube-proxy-9qhnz, continuing command...
There are pending nodes to be drained:
 controlplane
cannot delete DaemonSet-managed Pods (use --ignore-daemonsets to ignore): kube-flannel/kube-flannel-ds-wmv97, kube-system/kube-proxy-9qhnz

controlplane ~ ✖ k drain controlplane --ignore-daemonsets 
node/controlplane already cordoned
Warning: ignoring DaemonSet-managed Pods: kube-flannel/kube-flannel-ds-wmv97, kube-system/kube-proxy-9qhnz
evicting pod kube-system/coredns-6678bcd974-cxt2f
evicting pod kube-system/coredns-6678bcd974-547bm
evicting pod default/blue-759779556-khhht
evicting pod default/blue-759779556-624pm
pod/blue-759779556-khhht evicted
pod/blue-759779556-624pm evicted
pod/coredns-6678bcd974-547bm evicted
pod/coredns-6678bcd974-cxt2f evicted
node/controlplane drained

controlplane ~ ➜  #9

controlplane ~ ➜  ^[[200~echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
-bash: $'\E[200~echo': command not found

controlplane ~ ➜  echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/sta
ble:/v1.35/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.35/deb/ /

controlplane ~ ➜  sudo apt update
sudo apt-cache madison kubeadm
Hit:1 https://download.docker.com/linux/ubuntu jammy InRelease
Hit:2 http://archive.ubuntu.com/ubuntu jammy InRelease              
Hit:3 http://security.ubuntu.com/ubuntu jammy-security InRelease    
Hit:4 http://archive.ubuntu.com/ubuntu jammy-updates InRelease
Hit:5 http://archive.ubuntu.com/ubuntu jammy-backports InRelease
Get:6 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.35/deb  InRelease [1,227 B]
Get:7 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.35/deb  Packages [8,855 B]
Fetched 10.1 kB in 0s (22.3 kB/s)     
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
99 packages can be upgraded. Run 'apt list --upgradable' to see them.
   kubeadm | 1.35.5-1.1 | https://pkgs.k8s.io/core:/stable:/v1.35/deb  Packages
   kubeadm | 1.35.4-1.1 | https://pkgs.k8s.io/core:/stable:/v1.35/deb  Packages
   kubeadm | 1.35.3-1.1 | https://pkgs.k8s.io/core:/stable:/v1.35/deb  Packages
   kubeadm | 1.35.2-1.1 | https://pkgs.k8s.io/core:/stable:/v1.35/deb  Packages
   kubeadm | 1.35.1-1.1 | https://pkgs.k8s.io/core:/stable:/v1.35/deb  Packages
   kubeadm | 1.35.0-1.1 | https://pkgs.k8s.io/core:/stable:/v1.35/deb  Packages

controlplane ~ ➜  sudo apt-mark unhold kubeadm && \
sudo apt-get update && sudo apt-get install -y kubeadm='1.35.0-1.1' && \
sudo apt-mark hold kubeadm
kubeadm was already not on hold.
Hit:1 https://download.docker.com/linux/ubuntu jammy InRelease
Hit:2 http://archive.ubuntu.com/ubuntu jammy InRelease                                                           
Hit:3 http://security.ubuntu.com/ubuntu jammy-security InRelease    
Hit:4 http://archive.ubuntu.com/ubuntu jammy-updates InRelease
Hit:5 http://archive.ubuntu.com/ubuntu jammy-backports InRelease
Hit:6 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.35/deb  InRelease
Reading package lists... Done              
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following packages will be upgraded:
  kubeadm
1 upgraded, 0 newly installed, 0 to remove and 98 not upgraded.
Need to get 12.4 MB of archives.
After this operation, 1,659 kB disk space will be freed.
Get:1 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.35/deb  kubeadm 1.35.0-1.1 [12.4 MB]
Fetched 12.4 MB in 0s (29.6 MB/s)
debconf: delaying package configuration, since apt-utils is not installed
(Reading database ... 20567 files and directories currently installed.)
Preparing to unpack .../kubeadm_1.35.0-1.1_amd64.deb ...
Unpacking kubeadm (1.35.0-1.1) over (1.34.0-1.1) ...
Setting up kubeadm (1.35.0-1.1) ...
kubeadm set on hold.

controlplane ~ ➜  sudo kubeadm upgrade plan
[preflight] Running pre-flight checks.
[upgrade/config] Reading configuration from the "kubeadm-config" ConfigMap in namespace "kube-system"...
[upgrade/config] Use 'kubeadm init phase upload-config kubeadm --config your-config-file' to re-upload it.
[upgrade] Running cluster health checks
[upgrade] Fetching available versions to upgrade to
[upgrade/versions] Cluster version: 1.34.0
[upgrade/versions] kubeadm version: v1.35.0
I0608 14:46:08.377844   29142 version.go:260] remote version is much newer: v1.36.1; falling back to: stable-1.35
[upgrade/versions] Target version: v1.35.5
[upgrade/versions] Latest version in the v1.34 series: v1.34.8

Components that must be upgraded manually after you have upgraded the control plane with 'kubeadm upgrade apply':
COMPONENT   NODE           CURRENT   TARGET
kubelet     controlplane   v1.34.0   v1.34.8
kubelet     node01         v1.34.0   v1.34.8

Upgrade to the latest version in the v1.34 series:

COMPONENT                 NODE           CURRENT   TARGET
kube-apiserver            controlplane   v1.34.0   v1.34.8
kube-controller-manager   controlplane   v1.34.0   v1.34.8
kube-scheduler            controlplane   v1.34.0   v1.34.8
kube-proxy                               1.34.0    v1.34.8
CoreDNS                                  v1.10.1   v1.13.1
etcd                      controlplane   3.6.4-0   3.6.6-0

You can now apply the upgrade by executing the following command:

        kubeadm upgrade apply v1.34.8

_____________________________________________________________________

Components that must be upgraded manually after you have upgraded the control plane with 'kubeadm upgrade apply':
COMPONENT   NODE           CURRENT   TARGET
kubelet     controlplane   v1.34.0   v1.35.5
kubelet     node01         v1.34.0   v1.35.5

Upgrade to the latest stable version:

COMPONENT                 NODE           CURRENT   TARGET
kube-apiserver            controlplane   v1.34.0   v1.35.5
kube-controller-manager   controlplane   v1.34.0   v1.35.5
kube-scheduler            controlplane   v1.34.0   v1.35.5
kube-proxy                               1.34.0    v1.35.5
CoreDNS                                  v1.10.1   v1.13.1
etcd                      controlplane   3.6.4-0   3.6.6-0

You can now apply the upgrade by executing the following command:

        kubeadm upgrade apply v1.35.5

Note: Before you can perform this upgrade, you have to update kubeadm to v1.35.5.

_____________________________________________________________________


The table below shows the current state of component configs as understood by this version of kubeadm.
Configs that have a "yes" mark in the "MANUAL UPGRADE REQUIRED" column require manual config upgrade or
resetting to kubeadm defaults before a successful upgrade can be performed. The version to manually
upgrade to is denoted in the "PREFERRED VERSION" column.

API GROUP                 CURRENT VERSION   PREFERRED VERSION   MANUAL UPGRADE REQUIRED
kubeproxy.config.k8s.io   v1alpha1          v1alpha1            no
kubelet.config.k8s.io     v1beta1           v1beta1             no
_____________________________________________________________________


controlplane ~ ➜  sudo kubeadm upgrade apply v1.35.0
[upgrade] Reading configuration from the "kubeadm-config" ConfigMap in namespace "kube-system"...
[upgrade] Use 'kubeadm init phase upload-config kubeadm --config your-config-file' to re-upload it.
[upgrade/preflight] Running preflight checks
        [WARNING ContainerRuntimeVersion]: You must update your container runtime to a version that supports the CRI method RuntimeConfig. Falling back to using cgroupDriver from kubelet config will be removed in 1.36. For more information, see https://git.k8s.io/enhancements/keps/sig-node/4033-group-driver-detection-over-cri
[upgrade] Running cluster health checks
[upgrade/preflight] You have chosen to upgrade the cluster version to "v1.35.0"
[upgrade/versions] Cluster version: v1.34.0
[upgrade/versions] kubeadm version: v1.35.0
[upgrade] Are you sure you want to proceed? [y/N]: y
[upgrade/preflight] Pulling images required for setting up a Kubernetes cluster
[upgrade/preflight] This might take a minute or two, depending on the speed of your internet connection
[upgrade/preflight] You can also perform this action beforehand using 'kubeadm config images pull'
W0608 14:47:02.140629   29430 checks.go:906] detected that the sandbox image "registry.k8s.io/pause:3.6" of the container runtime is inconsistent with that used by kubeadm. It is recommended to use "registry.k8s.io/pause:3.10.1" as the CRI sandbox image.
[upgrade/control-plane] Upgrading your static Pod-hosted control plane to version "v1.35.0" (timeout: 5m0s)...
[upgrade/staticpods] Writing new Static Pod manifests to "/etc/kubernetes/tmp/kubeadm-upgraded-manifests3394146806"
[upgrade/staticpods] Preparing for "etcd" upgrade
[upgrade/staticpods] Renewing etcd-server certificate
[upgrade/staticpods] Renewing etcd-peer certificate
[upgrade/staticpods] Renewing etcd-healthcheck-client certificate
[upgrade/staticpods] Moving new manifest to "/etc/kubernetes/manifests/etcd.yaml" and backing up old manifest to "/etc/kubernetes/tmp/kubeadm-backup-manifests-2026-06-08-14-47-14/etcd.yaml"
[upgrade/staticpods] Waiting for the kubelet to restart the component
[upgrade/staticpods] This can take up to 5m0s
[apiclient] Found 1 Pods for label selector component=etcd
[upgrade/staticpods] Component "etcd" upgraded successfully!
[upgrade/etcd] Waiting for etcd to become available
[upgrade/staticpods] Preparing for "kube-apiserver" upgrade
[upgrade/staticpods] Renewing apiserver certificate
[upgrade/staticpods] Renewing apiserver-kubelet-client certificate
[upgrade/staticpods] Renewing front-proxy-client certificate
[upgrade/staticpods] Renewing apiserver-etcd-client certificate
[upgrade/staticpods] Moving new manifest to "/etc/kubernetes/manifests/kube-apiserver.yaml" and backing up old manifest to "/etc/kubernetes/tmp/kubeadm-backup-manifests-2026-06-08-14-47-14/kube-apiserver.yaml"
[upgrade/staticpods] Waiting for the kubelet to restart the component
[upgrade/staticpods] This can take up to 5m0s
[apiclient] Found 1 Pods for label selector component=kube-apiserver
[upgrade/staticpods] Component "kube-apiserver" upgraded successfully!
[upgrade/staticpods] Preparing for "kube-controller-manager" upgrade
[upgrade/staticpods] Renewing controller-manager.conf certificate
[upgrade/staticpods] Moving new manifest to "/etc/kubernetes/manifests/kube-controller-manager.yaml" and backing up old manifest to "/etc/kubernetes/tmp/kubeadm-backup-manifests-2026-06-08-14-47-14/kube-controller-manager.yaml"
[upgrade/staticpods] Waiting for the kubelet to restart the component
[upgrade/staticpods] This can take up to 5m0s
[apiclient] Found 1 Pods for label selector component=kube-controller-manager
[upgrade/staticpods] Component "kube-controller-manager" upgraded successfully!
[upgrade/staticpods] Preparing for "kube-scheduler" upgrade
[upgrade/staticpods] Renewing scheduler.conf certificate
[upgrade/staticpods] Moving new manifest to "/etc/kubernetes/manifests/kube-scheduler.yaml" and backing up old manifest to "/etc/kubernetes/tmp/kubeadm-backup-manifests-2026-06-08-14-47-14/kube-scheduler.yaml"
[upgrade/staticpods] Waiting for the kubelet to restart the component
[upgrade/staticpods] This can take up to 5m0s
[apiclient] Found 1 Pods for label selector component=kube-scheduler
[upgrade/staticpods] Component "kube-scheduler" upgraded successfully!
[upgrade/control-plane] The control plane instance for this node was successfully upgraded!
[upload-config] Storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
[kubelet] Creating a ConfigMap "kubelet-config" in namespace kube-system with the configuration for the kubelets in the cluster
[upgrade/kubeconfig] The kubeconfig files for this node were successfully upgraded!
W0608 14:50:58.905626   29430 postupgrade.go:105] Using temporary directory /etc/kubernetes/tmp/kubeadm-kubelet-config-2026-06-08-14-50-58 for kubelet config. To override it set the environment variable KUBEADM_UPGRADE_DRYRUN_DIR
[upgrade] Backing up kubelet config file to /etc/kubernetes/tmp/kubeadm-kubelet-config-2026-06-08-14-50-58/config.yaml
[patches] Applied patch of type "application/strategic-merge-patch+json" to target "kubeletconfiguration"
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[upgrade/kubelet-config] The kubelet configuration for this node was successfully upgraded!
[upgrade/bootstrap-token] Configuring bootstrap token and cluster-info RBAC rules
[bootstrap-token] Configured RBAC rules to allow Node Bootstrap tokens to get nodes
[bootstrap-token] Configured RBAC rules to allow Node Bootstrap tokens to post CSRs in order for nodes to get long term certificate credentials
[bootstrap-token] Configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token
[bootstrap-token] Configured RBAC rules to allow certificate rotation for all node client certificates in the cluster
[addons] Applied essential addon: CoreDNS
[addons] Applied essential addon: kube-proxy
W0608 14:51:03.290458   29430 postupgrade.go:203] Using temporary directory /etc/kubernetes/tmp/kubeadm-kubelet-env3966514992 for kubelet env file. To override it set the environment variable KUBEADM_UPGRADE_DRYRUN_DIR
[upgrade] Backing up kubelet env file to /etc/kubernetes/tmp/kubeadm-kubelet-env3966514992/kubeadm-flags.env
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"

[upgrade] SUCCESS! A control plane node of your cluster was upgraded to "v1.35.0".

[upgrade] Now please proceed with upgrading the rest of the nodes by following the right order.

controlplane ~ ➜  k drain node01 
node/node01 cordoned
error: unable to drain node "node01" due to error: cannot delete DaemonSet-managed Pods (use --ignore-daemonsets to ignore): kube-flannel/kube-flannel-ds-5l65n, kube-system/kube-proxy-7vml7, continuing command...
There are pending nodes to be drained:
 node01
cannot delete DaemonSet-managed Pods (use --ignore-daemonsets to ignore): kube-flannel/kube-flannel-ds-5l65n, kube-system/kube-proxy-7vml7

controlplane ~ ✖ k drain node01 --ignore-daemonsets 
node/node01 already cordoned
Warning: ignoring DaemonSet-managed Pods: kube-flannel/kube-flannel-ds-5l65n, kube-system/kube-proxy-7vml7
evicting pod kube-system/coredns-7d764666f9-xxjhc
evicting pod default/blue-759779556-rj5c9
evicting pod kube-system/coredns-7d764666f9-v9x4x
evicting pod default/blue-759779556-zg4fs
evicting pod default/blue-759779556-mfsbx
evicting pod default/blue-759779556-hvtqt
evicting pod default/blue-759779556-fp6kw
pod/blue-759779556-fp6kw evicted
pod/blue-759779556-mfsbx evicted
pod/blue-759779556-zg4fs evicted
pod/blue-759779556-hvtqt evicted
pod/blue-759779556-rj5c9 evicted
pod/coredns-7d764666f9-v9x4x evicted
pod/coredns-7d764666f9-xxjhc evicted
node/node01 drained

controlplane ~ ➜  sudo apt-mark unhold kubelet kubectl && \
sudo apt-get update && sudo apt-get install -y kubelet='1.35.0-1' kubectl='1.35.0-1' && \
sudo apt-mark hold kubelet kubectl
kubelet was already not on hold.
kubectl was already not on hold.
Hit:1 https://download.docker.com/linux/ubuntu jammy InRelease
Hit:2 http://archive.ubuntu.com/ubuntu jammy InRelease              
Hit:3 http://security.ubuntu.com/ubuntu jammy-security InRelease    
Hit:4 http://archive.ubuntu.com/ubuntu jammy-updates InRelease
Hit:5 http://archive.ubuntu.com/ubuntu jammy-backports InRelease
Hit:6 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.35/deb  InRelease
Reading package lists... Done
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
Package kubectl is not available, but is referred to by another package.
This may mean that the package is missing, has been obsoleted, or
is only available from another source

Package kubelet is not available, but is referred to by another package.
This may mean that the package is missing, has been obsoleted, or
is only available from another source

E: Version '1.35.0-1' for 'kubelet' was not found
E: Version '1.35.0-1' for 'kubectl' was not found

controlplane ~ ✖ sudo apt-mark unhold kubelet kubectl && sudo apt-get update && sudo apt-get install -y kubelet='1.35.0-1
.1' kubectl='1.35.0-1.1' && sudo apt-mark hold kubelet kubectl
kubelet was already not on hold.
kubectl was already not on hold.
Hit:1 https://download.docker.com/linux/ubuntu jammy InRelease
Hit:2 http://archive.ubuntu.com/ubuntu jammy InRelease                                             
Hit:3 http://security.ubuntu.com/ubuntu jammy-security InRelease                                   
Hit:4 http://archive.ubuntu.com/ubuntu jammy-updates InRelease      
Hit:5 http://archive.ubuntu.com/ubuntu jammy-backports InRelease
Hit:6 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.35/deb  InRelease
Reading package lists... Done
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following packages were automatically installed and are no longer required:
  conntrack ethtool
Use 'sudo apt autoremove' to remove them.
The following packages will be upgraded:
  kubectl kubelet
2 upgraded, 0 newly installed, 0 to remove and 97 not upgraded.
Need to get 24.4 MB of archives.
After this operation, 3,047 kB disk space will be freed.
Get:1 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.35/deb  kubectl 1.35.0-1.1 [11.5 MB]
Get:2 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.35/deb  kubelet 1.35.0-1.1 [12.9 MB]
Fetched 24.4 MB in 1s (42.8 MB/s)
debconf: delaying package configuration, since apt-utils is not installed
(Reading database ... 20567 files and directories currently installed.)
Preparing to unpack .../kubectl_1.35.0-1.1_amd64.deb ...
Unpacking kubectl (1.35.0-1.1) over (1.34.0-1.1) ...
Preparing to unpack .../kubelet_1.35.0-1.1_amd64.deb ...
Unpacking kubelet (1.35.0-1.1) over (1.34.0-1.1) ...
Setting up kubectl (1.35.0-1.1) ...
Setting up kubelet (1.35.0-1.1) ...
kubelet set on hold.
kubectl set on hold.

controlplane ~ ➜  k get node
NAME           STATUS                     ROLES           AGE   VERSION
controlplane   Ready,SchedulingDisabled   control-plane   54m   v1.34.0
node01         Ready,SchedulingDisabled   <none>          53m   v1.34.0

controlplane ~ ➜  sudo systemctl daemon-reload
sudo systemctl restart kubelet

controlplane ~ ➜  k get node
The connection to the server controlplane:6443 was refused - did you specify the right host or port?

controlplane ~ ✖ k get node
The connection to the server controlplane:6443 was refused - did you specify the right host or port?

controlplane ~ ✖ k get node
Error from server (Forbidden): nodes is forbidden: User "kubernetes-admin" cannot list resource "nodes" in API group "" at the cluster scope

controlplane ~ ✖ k get nodes
NAME           STATUS                     ROLES           AGE   VERSION
controlplane   Ready,SchedulingDisabled   control-plane   54m   v1.35.0
node01         Ready,SchedulingDisabled   <none>          54m   v1.34.0

controlplane ~ ➜  k get nodes
NAME           STATUS                     ROLES           AGE   VERSION
controlplane   Ready,SchedulingDisabled   control-plane   55m   v1.35.0
node01         Ready,SchedulingDisabled   <none>          54m   v1.34.0

controlplane ~ ➜  #10

controlplane ~ ➜  k uncordon controlplane 
node/controlplane uncordoned

controlplane ~ ➜  #11

controlplane ~ ➜  k cordon node01 
node/node01 already cordoned

controlplane ~ ➜  #12

controlplane ~ ➜  ssh node01
Welcome to Ubuntu 22.04.5 LTS (GNU/Linux 6.8.0-90-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

This system has been minimized by removing packages and content that are
not required on a system that users do not log into.

To restore this content, you can run the 'unminimize' command.

node01 ~ ➜  echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.35/deb/ /" | sudo tee /etc/apt/sources.list
.d/kubernetes.list
deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.35/deb/ /

node01 ~ ➜  sudo apt update
sudo apt-cache madison kubeadm
Get:1 https://download.docker.com/linux/ubuntu jammy InRelease [48.5 kB]
Hit:2 http://archive.ubuntu.com/ubuntu jammy InRelease                                                
Get:3 http://security.ubuntu.com/ubuntu jammy-security InRelease [129 kB]
Get:4 http://archive.ubuntu.com/ubuntu jammy-updates InRelease [128 kB]       
Get:5 https://download.docker.com/linux/ubuntu jammy/stable amd64 Packages [96.4 kB]     
Get:7 http://archive.ubuntu.com/ubuntu jammy-backports InRelease [127 kB]                 
Get:6 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.35/deb  InRelease [1,227 B]
Get:8 http://security.ubuntu.com/ubuntu jammy-security/restricted amd64 Packages [7,183 kB]
Get:9 http://archive.ubuntu.com/ubuntu jammy-updates/restricted amd64 Packages [7,489 kB]
Get:10 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.35/deb  Packages [8,855 B]
Get:11 http://security.ubuntu.com/ubuntu jammy-security/universe amd64 Packages [1,300 kB]            
Get:12 http://security.ubuntu.com/ubuntu jammy-security/multiverse amd64 Packages [77.8 kB]
Get:13 http://security.ubuntu.com/ubuntu jammy-security/main amd64 Packages [4,005 kB]          
Get:14 http://archive.ubuntu.com/ubuntu jammy-updates/multiverse amd64 Packages [86.4 kB]      
Get:15 http://archive.ubuntu.com/ubuntu jammy-updates/universe amd64 Packages [1,607 kB]
Get:16 http://archive.ubuntu.com/ubuntu jammy-updates/main amd64 Packages [4,354 kB]
Get:17 http://archive.ubuntu.com/ubuntu jammy-backports/main amd64 Packages [82.8 kB]
Get:18 http://archive.ubuntu.com/ubuntu jammy-backports/universe amd64 Packages [35.6 kB]
Fetched 26.8 MB in 1s (20.2 MB/s)                           
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
99 packages can be upgraded. Run 'apt list --upgradable' to see them.
   kubeadm | 1.35.5-1.1 | https://pkgs.k8s.io/core:/stable:/v1.35/deb  Packages
   kubeadm | 1.35.4-1.1 | https://pkgs.k8s.io/core:/stable:/v1.35/deb  Packages
   kubeadm | 1.35.3-1.1 | https://pkgs.k8s.io/core:/stable:/v1.35/deb  Packages
   kubeadm | 1.35.2-1.1 | https://pkgs.k8s.io/core:/stable:/v1.35/deb  Packages
   kubeadm | 1.35.1-1.1 | https://pkgs.k8s.io/core:/stable:/v1.35/deb  Packages
   kubeadm | 1.35.0-1.1 | https://pkgs.k8s.io/core:/stable:/v1.35/deb  Packages

node01 ~ ➜  sudo apt-mark unhold kubeadm && \ sudo apt-get update && sudo apt-get install -y kubeadm='1.35.x-0.1' && \ sudo apt-mark hold kubeadm
Canceled hold on kubeadm.
-bash:  sudo: command not found

node01 ~ ✖ sudo kubeadm upgrade node
[upgrade] Reading configuration from the "kubeadm-config" ConfigMap in namespace "kube-system"...
[upgrade] Use 'kubeadm init phase upload-config kubeadm --config your-config-file' to re-upload it.
[upgrade/preflight] Running pre-flight checks
[upgrade/preflight] Skipping prepull. Not a control plane node.
[upgrade/control-plane] Skipping phase. Not a control plane node.
[upgrade/kubeconfig] Skipping phase. Not a control plane node.
W0608 15:02:34.778953   59759 postupgrade.go:116] Using temporary directory /etc/kubernetes/tmp/kubeadm-kubelet-config3471861018 for kubelet config. To override it set the environment variable KUBEADM_UPGRADE_DRYRUN_DIR
[upgrade] Backing up kubelet config file to /etc/kubernetes/tmp/kubeadm-kubelet-config3471861018/config.yaml
[patches] Applied patch of type "application/strategic-merge-patch+json" to target "kubeletconfiguration"
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[upgrade/kubelet-config] The kubelet configuration for this node was successfully upgraded!
[upgrade/addon] Skipping the addon/coredns phase. Not a control plane node.
[upgrade/addon] Skipping the addon/kube-proxy phase. Not a control plane node.

node01 ~ ➜  sudo apt-mark unhold kubeadm && \ sudo apt-get update && sudo apt-get install -y kubeadm='1.35.0-0.1' && \ sudo apt-mark hold kubeadm
kubeadm was already not on hold.
-bash:  sudo: command not found

node01 ~ ✖ sudo apt-get install -y kubeadm='1.35.0-0.1'
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
Package kubeadm is not available, but is referred to by another package.
This may mean that the package is missing, has been obsoleted, or
is only available from another source

E: Version '1.35.0-0.1' for 'kubeadm' was not found

node01 ~ ✖ sudo apt-get install -y kubeadm='1.35.0-1.1'
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following packages will be upgraded:
  kubeadm
1 upgraded, 0 newly installed, 0 to remove and 98 not upgraded.
Need to get 12.4 MB of archives.
After this operation, 1,659 kB disk space will be freed.
Get:1 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.35/deb  kubeadm 1.35.0-1.1 [12.4 MB]
Fetched 12.4 MB in 1s (19.8 MB/s)
debconf: delaying package configuration, since apt-utils is not installed
(Reading database ... 17482 files and directories currently installed.)
Preparing to unpack .../kubeadm_1.35.0-1.1_amd64.deb ...
Unpacking kubeadm (1.35.0-1.1) over (1.34.0-1.1) ...
Setting up kubeadm (1.35.0-1.1) ...

node01 ~ ➜  sudo apt-mark unhold kubeadm && \ sudo apt-get update && sudo apt-get install -y kubeadm='1.35.0-0.1' && \ sudo apt-mark hold kubeadm
kubeadm was already not on hold.
-bash:  sudo: command not found

node01 ~ ✖ sudo apt-mark unhold kubeadm
kubeadm was already not on hold.

node01 ~ ➜  sudo apt-mark hold kubeadm
kubeadm set on hold.

node01 ~ ➜  sudo kubeadm upgrade node
[upgrade] Reading configuration from the "kubeadm-config" ConfigMap in namespace "kube-system"...
[upgrade] Use 'kubeadm init phase upload-config kubeadm --config your-config-file' to re-upload it.
[upgrade/preflight] Running pre-flight checks
        [WARNING ContainerRuntimeVersion]: You must update your container runtime to a version that supports the CRI method RuntimeConfig. Falling back to using cgroupDriver from kubelet config will be removed in 1.36. For more information, see https://git.k8s.io/enhancements/keps/sig-node/4033-group-driver-detection-over-cri
[upgrade/preflight] Skipping prepull. Not a control plane node.
[upgrade/control-plane] Skipping phase. Not a control plane node.
[upgrade/kubeconfig] Skipping phase. Not a control plane node.
W0608 15:04:52.210326   60920 postupgrade.go:105] Using temporary directory /etc/kubernetes/tmp/kubeadm-kubelet-config-2026-06-08-15-04-52 for kubelet config. To override it set the environment variable KUBEADM_UPGRADE_DRYRUN_DIR
[upgrade] Backing up kubelet config file to /etc/kubernetes/tmp/kubeadm-kubelet-config-2026-06-08-15-04-52/config.yaml
[patches] Applied patch of type "application/strategic-merge-patch+json" to target "kubeletconfiguration"
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[upgrade/kubelet-config] The kubelet configuration for this node was successfully upgraded!
[upgrade/addon] Skipping the addon/coredns phase. Not a control plane node.
[upgrade/addon] Skipping the addon/kube-proxy phase. Not a control plane node.
W0608 15:04:52.236817   60920 postupgrade.go:203] Using temporary directory /etc/kubernetes/tmp/kubeadm-kubelet-env4199409206 for kubelet env file. To override it set the environment variable KUBEADM_UPGRADE_DRYRUN_DIR
[upgrade] Backing up kubelet env file to /etc/kubernetes/tmp/kubeadm-kubelet-env4199409206/kubeadm-flags.env
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"

node01 ~ ➜  sudo apt-mark unhold kubelet kubectl && \
sudo apt-get update && sudo apt-get install -y kubelet='1.35.0-1.1' kubectl='1.35.0-1.1' && \
sudo apt-mark hold kubelet kubectl
Canceled hold on kubelet.
Canceled hold on kubectl.
Hit:1 https://download.docker.com/linux/ubuntu jammy InRelease
Hit:2 http://archive.ubuntu.com/ubuntu jammy InRelease              
Hit:3 http://security.ubuntu.com/ubuntu jammy-security InRelease    
Hit:4 http://archive.ubuntu.com/ubuntu jammy-updates InRelease
Hit:5 http://archive.ubuntu.com/ubuntu jammy-backports InRelease
Hit:6 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.35/deb  InRelease
Reading package lists... Done                            
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following packages were automatically installed and are no longer required:
  conntrack ethtool
Use 'sudo apt autoremove' to remove them.
The following packages will be upgraded:
  kubectl kubelet
2 upgraded, 0 newly installed, 0 to remove and 97 not upgraded.
Need to get 24.4 MB of archives.
After this operation, 3,047 kB disk space will be freed.
Get:1 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.35/deb  kubectl 1.35.0-1.1 [11.5 MB]
Get:2 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.35/deb  kubelet 1.35.0-1.1 [12.9 MB]
Fetched 24.4 MB in 1s (17.9 MB/s)  
debconf: delaying package configuration, since apt-utils is not installed
(Reading database ... 17482 files and directories currently installed.)
Preparing to unpack .../kubectl_1.35.0-1.1_amd64.deb ...
Unpacking kubectl (1.35.0-1.1) over (1.34.0-1.1) ...
Preparing to unpack .../kubelet_1.35.0-1.1_amd64.deb ...
Unpacking kubelet (1.35.0-1.1) over (1.34.0-1.1) ...
Setting up kubectl (1.35.0-1.1) ...
Setting up kubelet (1.35.0-1.1) ...
kubelet set on hold.
kubectl set on hold.

node01 ~ ➜  sudo systemctl daemon-reload
sudo systemctl restart kubelet

node01 ~ ➜  k get node
E0608 15:05:55.801153   62355 memcache.go:265] "Unhandled Error" err="couldn't get current server API group list: the server could not find the requested resource"
E0608 15:05:55.802016   62355 memcache.go:265] "Unhandled Error" err="couldn't get current server API group list: the server could not find the requested resource"
E0608 15:05:55.803880   62355 memcache.go:265] "Unhandled Error" err="couldn't get current server API group list: the server could not find the requested resource"
E0608 15:05:55.805032   62355 memcache.go:265] "Unhandled Error" err="couldn't get current server API group list: the server could not find the requested resource"
E0608 15:05:55.805822   62355 memcache.go:265] "Unhandled Error" err="couldn't get current server API group list: the server could not find the requested resource"
Error from server (NotFound): the server could not find the requested resource

node01 ~ ✖ 
logout
Connection to node01 closed.

controlplane ~ ✖ k get node
NAME           STATUS                     ROLES           AGE   VERSION
controlplane   Ready                      control-plane   67m   v1.35.0
node01         Ready,SchedulingDisabled   <none>          66m   v1.35.0

controlplane ~ ➜  
```

# Backup and restore etcd
```cmd
           Welcome to the KodeKloud Hands-On lab                                                                                                                                     
    __ ______  ____  ________ __ __    ____  __  ______ 
   / //_/ __ \/ __ \/ ____/ //_// /   / __ \/ / / / __ \
  / ,< / / / / / / / __/ / ,<  / /   / / / / / / / / / /
 / /| / /_/ / /_/ / /___/ /| |/ /___/ /_/ / /_/ / /_/ / 
/_/ |_\____/_____/_____/_/ |_/_____/\____/\____/_____/  
                                                        
                   All rights reserved                                                                                                                                               

controlplane ~ ➜  #1

controlplane ~ ➜  k get deploy 
NAME   READY   UP-TO-DATE   AVAILABLE   AGE
blue   3/3     3            3           28s
red    2/2     2            2           28s

controlplane ~ ➜  #2

controlplane ~ ➜  k get -n kube-system 
You must specify the type of resource to get. Use "kubectl api-resources" for a complete list of supported resources.

error: Required resource not specified.
Use "kubectl explain <resource>" for a detailed description of that resource (e.g. kubectl explain pods).
See 'kubectl get -h' for help and examples

controlplane ~ ✖ k get po -n kube-system 
NAME                                   READY   STATUS    RESTARTS   AGE
coredns-6f6c7df987-khqdp               1/1     Running   0          6m31s
coredns-6f6c7df987-x4sm5               1/1     Running   0          6m31s
etcd-controlplane                      1/1     Running   0          6m37s
kube-apiserver-controlplane            1/1     Running   0          6m37s
kube-controller-manager-controlplane   1/1     Running   0          6m37s
kube-proxy-sd2db                       1/1     Running   0          6m31s
kube-scheduler-controlplane            1/1     Running   0          6m37s

controlplane ~ ➜  k describe etcd-controlplane
error: the server doesn't have a resource type "etcd-controlplane"

controlplane ~ ✖ k get etcd-controlplane -oyaml
error: the server doesn't have a resource type "etcd-controlplane"

controlplane ~ ✖ k get etcd-controlplane -oyaml -A
error: the server doesn't have a resource type "etcd-controlplane"

controlplane ~ ✖ k get etcd-controlplane -oyaml -n kube-system 
error: the server doesn't have a resource type "etcd-controlplane"

controlplane ~ ✖ k describe etcd-controlplane -n kube-system 
error: the server doesn't have a resource type "etcd-controlplane"

controlplane ~ ✖ k describe pod etcd-controlplane -n kube-system 
Name:                 etcd-controlplane
Namespace:            kube-system
Priority:             2000001000
Priority Class Name:  system-node-critical
Node:                 controlplane/10.244.166.6
Start Time:           Wed, 10 Jun 2026 12:33:17 +0000
Labels:               component=etcd
                      tier=control-plane
Annotations:          kubeadm.kubernetes.io/etcd.advertise-client-urls: https://10.244.166.6:2379
                      kubernetes.io/config.hash: cdbd826d2a0d3d9fbc2fd0cd7bc7bc09
                      kubernetes.io/config.mirror: cdbd826d2a0d3d9fbc2fd0cd7bc7bc09
                      kubernetes.io/config.seen: 2026-06-10T12:33:17.053704466Z
                      kubernetes.io/config.source: file
Status:               Running
SeccompProfile:       RuntimeDefault
IP:                   10.244.166.6
IPs:
  IP:           10.244.166.6
Controlled By:  Node/controlplane
Containers:
  etcd:
    Container ID:  containerd://9c26cd1e6d71f4fd4cfd2b90f08063703cc94ef469d600cc4b6f4a152ad5a3a0
    Image:         registry.k8s.io/etcd:3.6.6-0
    Image ID:      registry.k8s.io/etcd@sha256:60a30b5d81b2217555e2cfb9537f655b7ba97220b99c39ee2e162a7127225890
    Port:          2381/TCP (probe-port)
    Host Port:     2381/TCP (probe-port)
    Command:
      etcd
      --advertise-client-urls=https://10.244.166.6:2379
      --cert-file=/etc/kubernetes/pki/etcd/server.crt
      --client-cert-auth=true
      --data-dir=/var/lib/etcd
      --feature-gates=InitialCorruptCheck=true
      --initial-advertise-peer-urls=https://10.244.166.6:2380
      --initial-cluster=controlplane=https://10.244.166.6:2380
      --key-file=/etc/kubernetes/pki/etcd/server.key
      --listen-client-urls=https://127.0.0.1:2379,https://10.244.166.6:2379
      --listen-metrics-urls=http://127.0.0.1:2381
      --listen-peer-urls=https://10.244.166.6:2380
      --name=controlplane
      --peer-cert-file=/etc/kubernetes/pki/etcd/peer.crt
      --peer-client-cert-auth=true
      --peer-key-file=/etc/kubernetes/pki/etcd/peer.key
      --peer-trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt
      --snapshot-count=10000
      --trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt
      --watch-progress-notify-interval=5s
    State:          Running
      Started:      Wed, 10 Jun 2026 12:33:12 +0000
    Ready:          True
    Restart Count:  0
    Requests:
      cpu:        100m
      memory:     100Mi
    Liveness:     http-get http://127.0.0.1:probe-port/livez delay=10s timeout=15s period=10s #success=1 #failure=8
    Readiness:    http-get http://127.0.0.1:probe-port/readyz delay=0s timeout=15s period=1s #success=1 #failure=3
    Startup:      http-get http://127.0.0.1:probe-port/readyz delay=10s timeout=15s period=10s #success=1 #failure=24
    Environment:  <none>
    Mounts:
      /etc/kubernetes/pki/etcd from etcd-certs (rw)
      /var/lib/etcd from etcd-data (rw)
Conditions:
  Type                        Status
  PodReadyToStartContainers   True 
  Initialized                 True 
  Ready                       True 
  ContainersReady             True 
  PodScheduled                True 
Volumes:
  etcd-certs:
    Type:          HostPath (bare host directory volume)
    Path:          /etc/kubernetes/pki/etcd
    HostPathType:  DirectoryOrCreate
  etcd-data:
    Type:          HostPath (bare host directory volume)
    Path:          /var/lib/etcd
    HostPathType:  DirectoryOrCreate
QoS Class:         Burstable
Node-Selectors:    <none>
Tolerations:       :NoExecute op=Exists
Events:            <none>

controlplane ~ ➜  #3

controlplane ~ ➜  #4

controlplane ~ ➜  #5

controlplane ~ ➜  #6

controlplane ~ ➜  ETC --help
-bash: ETC: command not found

controlplane ~ ✖ etcdctl --help
NAME:
        etcdctl - A simple command line client for etcd3.

USAGE:
        etcdctl [flags]

VERSION:
        3.5.16

API VERSION:
        3.5


COMMANDS:
        alarm disarm            Disarms all alarms
        alarm list              Lists all alarms
        auth disable            Disables authentication
        auth enable             Enables authentication
        auth status             Returns authentication status
        check datascale         Check the memory usage of holding data for different workloads on a given server endpoint.
        check perf              Check the performance of the etcd cluster
        compaction              Compacts the event history in etcd
        defrag                  Defragments the storage of the etcd members with given endpoints
        del                     Removes the specified key or range of keys [key, range_end)
        elect                   Observes and participates in leader election
        endpoint hashkv         Prints the KV history hash for each endpoint in --endpoints
        endpoint health         Checks the healthiness of endpoints specified in `--endpoints` flag
        endpoint status         Prints out the status of endpoints specified in `--endpoints` flag
        get                     Gets the key or a range of keys
        help                    Help about any command
        lease grant             Creates leases
        lease keep-alive        Keeps leases alive (renew)
        lease list              List all active leases
        lease revoke            Revokes leases
        lease timetolive        Get lease information
        lock                    Acquires a named lock
        make-mirror             Makes a mirror at the destination etcd cluster
        member add              Adds a member into the cluster
        member list             Lists all members in the cluster
        member promote          Promotes a non-voting member in the cluster
        member remove           Removes a member from the cluster
        member update           Updates a member in the cluster
        move-leader             Transfers leadership to another etcd cluster member.
        put                     Puts the given key into the store
        role add                Adds a new role
        role delete             Deletes a role
        role get                Gets detailed information of a role
        role grant-permission   Grants a key to a role
        role list               Lists all roles
        role revoke-permission  Revokes a key from a role
        snapshot restore        Restores an etcd member snapshot to an etcd directory
        snapshot save           Stores an etcd node backend snapshot to a given file
        snapshot status         [deprecated] Gets backend snapshot status of a given file
        txn                     Txn processes all the requests in one transaction
        user add                Adds a new user
        user delete             Deletes a user
        user get                Gets detailed information of a user
        user grant-role         Grants a role to a user
        user list               Lists all users
        user passwd             Changes password of user
        user revoke-role        Revokes a role from a user
        version                 Prints the version of etcdctl
        watch                   Watches events stream on keys or prefixes

OPTIONS:
      --cacert=""                               verify certificates of TLS-enabled secure servers using this CA bundle
      --cert=""                                 identify secure client using this TLS certificate file
      --command-timeout=5s                      timeout for short running command (excluding dial timeout)
      --debug[=false]                           enable client-side debug logging
      --dial-timeout=2s                         dial timeout for client connections
  -d, --discovery-srv=""                        domain name to query for SRV records describing cluster endpoints
      --discovery-srv-name=""                   service name to query when using DNS discovery
      --endpoints=[127.0.0.1:2379]              gRPC endpoints
  -h, --help[=false]                            help for etcdctl
      --hex[=false]                             print byte strings as hex encoded strings
      --insecure-discovery[=true]               accept insecure SRV records describing cluster endpoints
      --insecure-skip-tls-verify[=false]        skip server certificate verification (CAUTION: this option should be enabled only for testing purposes)
      --insecure-transport[=true]               disable transport security for client connections
      --keepalive-time=2s                       keepalive time for client connections
      --keepalive-timeout=6s                    keepalive timeout for client connections
      --key=""                                  identify secure client using this TLS key file
      --password=""                             password for authentication (if this option is used, --user option shouldn't include password)
      --user=""                                 username[:password] for authentication (prompt if password is not supplied)
  -w, --write-out="simple"                      set the output format (fields, json, protobuf, simple, table)


controlplane ~ ➜  etcdctl snapshot save /opt/snapshot-pre-boot.db --cacert="/etc/kubernetes/pki/etcd/ca.crt" --cert="/etc/kubernetes/pki/etcd/server.crt" --endpoints="https://127.0.0.1:2379" --key="/etc/kubernetes/pki/etcd/server.key"
{"level":"info","ts":"2026-06-10T12:46:17.140136Z","caller":"snapshot/v3_snapshot.go:65","msg":"created temporary db file","path":"/opt/snapshot-pre-boot.db.part"}
{"level":"info","ts":"2026-06-10T12:46:17.145152Z","logger":"client","caller":"v3@v3.5.16/maintenance.go:212","msg":"opened snapshot stream; downloading"}
{"level":"info","ts":"2026-06-10T12:46:17.145188Z","caller":"snapshot/v3_snapshot.go:73","msg":"fetching snapshot","endpoint":"https://127.0.0.1:2379"}
{"level":"info","ts":"2026-06-10T12:46:17.151706Z","logger":"client","caller":"v3@v3.5.16/maintenance.go:220","msg":"completed snapshot read; closing"}
{"level":"info","ts":"2026-06-10T12:46:17.152178Z","caller":"snapshot/v3_snapshot.go:88","msg":"fetched snapshot","endpoint":"https://127.0.0.1:2379","size":"2.0 MB","took":"now"}
{"level":"info","ts":"2026-06-10T12:46:17.152257Z","caller":"snapshot/v3_snapshot.go:97","msg":"saved","path":"/opt/snapshot-pre-boot.db"}
Snapshot saved at /opt/snapshot-pre-boot.db

controlplane ~ ➜  #7

controlplane ~ ➜  #8

controlplane ~ ➜  k get deploy
No resources found in default namespace.

controlplane ~ ➜  k get pod 
No resources found in default namespace.

controlplane ~ ➜  ls /etc/kubernetes/manifests/
etcd.yaml  kube-apiserver.yaml  kube-controller-manager.yaml  kube-scheduler.yaml

controlplane ~ ➜  

controlplane ~ ➜  mv /etc/kubernetes/manifests/kube-apiserver.yaml 
mv: missing destination file operand after '/etc/kubernetes/manifests/kube-apiserver.yaml'
Try 'mv --help' for more information.

controlplane ~ ✖ mv /etc/kubernetes/manifests/kube-apiserver.yaml /tmp

controlplane ~ ➜  sleep 30000
^C

controlplane ~ ✖ ^C

controlplane ~ ✖ sleep 3000
^C

controlplane ~ ✖ sleep 30
^C

controlplane ~ ✖ etcductl --help
-bash: etcductl: command not found

controlplane ~ ✖ 

controlplane ~ ✖ cat /etc/kubernetes/manifests/etcd.yaml 
apiVersion: v1
kind: Pod
metadata:
  annotations:
    kubeadm.kubernetes.io/etcd.advertise-client-urls: https://10.244.166.6:2379
  labels:
    component: etcd
    tier: control-plane
  name: etcd
  namespace: kube-system
spec:
  containers:
  - command:
    - etcd
    - --advertise-client-urls=https://10.244.166.6:2379
    - --cert-file=/etc/kubernetes/pki/etcd/server.crt
    - --client-cert-auth=true
    - --data-dir=/var/lib/etcd
    - --feature-gates=InitialCorruptCheck=true
    - --initial-advertise-peer-urls=https://10.244.166.6:2380
    - --initial-cluster=controlplane=https://10.244.166.6:2380
    - --key-file=/etc/kubernetes/pki/etcd/server.key
    - --listen-client-urls=https://127.0.0.1:2379,https://10.244.166.6:2379
    - --listen-metrics-urls=http://127.0.0.1:2381
    - --listen-peer-urls=https://10.244.166.6:2380
    - --name=controlplane
    - --peer-cert-file=/etc/kubernetes/pki/etcd/peer.crt
    - --peer-client-cert-auth=true
    - --peer-key-file=/etc/kubernetes/pki/etcd/peer.key
    - --peer-trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt
    - --snapshot-count=10000
    - --trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt
    - --watch-progress-notify-interval=5s
    image: registry.k8s.io/etcd:3.6.6-0
    imagePullPolicy: IfNotPresent
    livenessProbe:
      failureThreshold: 8
      httpGet:
        host: 127.0.0.1
        path: /livez
        port: probe-port
        scheme: HTTP
      initialDelaySeconds: 10
      periodSeconds: 10
      timeoutSeconds: 15
    name: etcd
    ports:
    - containerPort: 2381
      name: probe-port
      protocol: TCP
    readinessProbe:
      failureThreshold: 3
      httpGet:
        host: 127.0.0.1
        path: /readyz
        port: probe-port
        scheme: HTTP
      periodSeconds: 1
      timeoutSeconds: 15
    resources:
      requests:
        cpu: 100m
        memory: 100Mi
    startupProbe:
      failureThreshold: 24
      httpGet:
        host: 127.0.0.1
        path: /readyz
        port: probe-port
        scheme: HTTP
      initialDelaySeconds: 10
      periodSeconds: 10
      timeoutSeconds: 15
    volumeMounts:
    - mountPath: /var/lib/etcd
      name: etcd-data
    - mountPath: /etc/kubernetes/pki/etcd
      name: etcd-certs
  hostNetwork: true
  priority: 2000001000
  priorityClassName: system-node-critical
  securityContext:
    seccompProfile:
      type: RuntimeDefault
  volumes:
  - hostPath:
      path: /etc/kubernetes/pki/etcd
      type: DirectoryOrCreate
    name: etcd-certs
  - hostPath:
      path: /var/lib/etcd
      type: DirectoryOrCreate
    name: etcd-data
status: {}

controlplane ~ ➜  etcdutl snapshot restore /opt/snapshot-pre-boot.db --data-dir=/var/lib/etcd-backup
2026-06-10T12:55:41Z    info    snapshot/v3_snapshot.go:265     restoring snapshot      {"path": "/opt/snapshot-pre-boot.db", "wal-dir": "/var/lib/etcd-backup/member/wal", "data-dir": "/var/lib/etcd-backup", "snap-dir": "/var/lib/etcd-backup/member/snap", "initial-memory-map-size": 10737418240}
2026-06-10T12:55:41Z    info    membership/store.go:141 Trimming membership information from the backend...
2026-06-10T12:55:41Z    info    membership/cluster.go:421       added member    {"cluster-id": "cdf818194e3a8c32", "local-member-id": "0", "added-peer-id": "8e9e05c52164694d", "added-peer-peer-urls": ["http://localhost:2380"]}
2026-06-10T12:55:41Z    info    snapshot/v3_snapshot.go:293     restored snapshot       {"path": "/opt/snapshot-pre-boot.db", "wal-dir": "/var/lib/etcd-backup/member/wal", "data-dir": "/var/lib/etcd-backup", "snap-dir": "/var/lib/etcd-backup/member/snap", "initial-memory-map-size": 10737418240}

controlplane ~ ➜  mv /tmp/kube-apiserver.yaml /etc/kubernetes/manifests/ 

controlplane ~ ➜  ls /etc/k
kernel/     kubernetes/ 
```