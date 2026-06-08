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