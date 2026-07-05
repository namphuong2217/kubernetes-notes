# Explore Environment
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
NAME           STATUS   ROLES           AGE   VERSION
controlplane   Ready    control-plane   18m   v1.35.0
node01         Ready    <none>          18m   v1.35.0

controlplane ~ ➜  #2

controlplane ~ ➜  k get nodes -A -o wide
NAME           STATUS   ROLES           AGE   VERSION   INTERNAL-IP     EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION     CONTAINER-RUNTIME
controlplane   Ready    control-plane   19m   v1.35.0   10.244.213.35   <none>        Ubuntu 22.04.5 LTS   6.8.0-90-generic   containerd://1.7.22
node01         Ready    <none>          18m   v1.35.0   10.244.213.63   <none>        Ubuntu 22.04.5 LTS   6.8.0-90-generic   containerd://1.7.22

controlplane ~ ➜  #3

controlplane ~ ➜  ip address | grep -i "controlplane"

controlplane ~ ✖ ip address
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: tunl0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN group default qlen 1000
    link/ipip 0.0.0.0 brd 0.0.0.0
4: eth0@if176588: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UP group default qlen 1000
    link/ether 1e:5a:5f:77:24:84 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 10.244.213.35/32 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::1c5a:5fff:fe77:2484/64 scope link 
       valid_lft forever preferred_lft forever
5: flannel.1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1400 qdisc noqueue state UNKNOWN group default 
    link/ether 82:47:4f:d2:2b:d8 brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.0/32 scope global flannel.1
       valid_lft forever preferred_lft forever
    inet6 fe80::8047:4fff:fed2:2bd8/64 scope link 
       valid_lft forever preferred_lft forever
6: cni0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1400 qdisc noqueue state UP group default qlen 1000
    link/ether 42:57:e7:48:c8:ee brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/24 brd 172.17.0.255 scope global cni0
       valid_lft forever preferred_lft forever
    inet6 fe80::4057:e7ff:fe48:c8ee/64 scope link 
       valid_lft forever preferred_lft forever
7: veth810591f5@if3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1400 qdisc noqueue master cni0 state UP group default 
    link/ether a6:80:4e:7b:4d:1a brd ff:ff:ff:ff:ff:ff link-netns cni-7ba0a8d4-62e6-fac6-5874-18ce9881ce61
    inet6 fe80::e45e:fbff:fe3b:b11e/64 scope link 
       valid_lft forever preferred_lft forever
8: veth5f18c45a@if3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1400 qdisc noqueue master cni0 state UP group default 
    link/ether 36:89:d6:f5:b6:63 brd ff:ff:ff:ff:ff:ff link-netns cni-36d53432-d47d-018a-ee21-8153e8bbd35e
    inet6 fe80::c4b5:aff:fedc:4dba/64 scope link 
       valid_lft forever preferred_lft forever

controlplane ~ ➜  ip address | grep -i "10.244.213.35" -C3
    link/ipip 0.0.0.0 brd 0.0.0.0
4: eth0@if176588: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UP group default qlen 1000
    link/ether 1e:5a:5f:77:24:84 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 10.244.213.35/32 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::1c5a:5fff:fe77:2484/64 scope link 
       valid_lft forever preferred_lft forever

controlplane ~ ➜  #4

controlplane ~ ➜  #5

controlplane ~ ➜  #6

controlplane ~ ➜  ip address | grep -i "213.63" -C3

controlplane ~ ✖ k get nodes
NAME           STATUS   ROLES           AGE   VERSION
controlplane   Ready    control-plane   23m   v1.35.0
node01         Ready    <none>          22m   v1.35.0

controlplane ~ ➜  k get nodes -o wide
NAME           STATUS   ROLES           AGE   VERSION   INTERNAL-IP     EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION     CONTAINER-RUNTIME
controlplane   Ready    control-plane   23m   v1.35.0   10.244.213.35   <none>        Ubuntu 22.04.5 LTS   6.8.0-90-generic   containerd://1.7.22
node01         Ready    <none>          22m   v1.35.0   10.244.213.63   <none>        Ubuntu 22.04.5 LTS   6.8.0-90-generic   containerd://1.7.22

controlplane ~ ➜  ssh node01
Welcome to Ubuntu 22.04.5 LTS (GNU/Linux 6.8.0-90-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

This system has been minimized by removing packages and content that are
not required on a system that users do not log into.

To restore this content, you can run the 'unminimize' command.

node01 ~ ➜  ip addrress
Object "addrress" is unknown, try "ip help".

node01 ~ ✖ ip link show eth0
4: eth0@if176589: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 66:63:4d:b9:eb:66 brd ff:ff:ff:ff:ff:ff link-netnsid 0

node01 ~ ➜  #6 What is the MAC address assigned to node01?

node01 ~ ➜  #7

node01 ~ ➜  exit
logout
Connection to node01 closed.

controlplane ~ ➜  ip link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: tunl0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ipip 0.0.0.0 brd 0.0.0.0
4: eth0@if176588: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 1e:5a:5f:77:24:84 brd ff:ff:ff:ff:ff:ff link-netnsid 0
5: flannel.1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1400 qdisc noqueue state UNKNOWN mode DEFAULT group default 
    link/ether 82:47:4f:d2:2b:d8 brd ff:ff:ff:ff:ff:ff
6: cni0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1400 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 42:57:e7:48:c8:ee brd ff:ff:ff:ff:ff:ff
7: veth810591f5@if3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1400 qdisc noqueue master cni0 state UP mode DEFAULT group default 
    link/ether a6:80:4e:7b:4d:1a brd ff:ff:ff:ff:ff:ff link-netns cni-7ba0a8d4-62e6-fac6-5874-18ce9881ce61
8: veth5f18c45a@if3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1400 qdisc noqueue master cni0 state UP mode DEFAULT group default 
    link/ether 36:89:d6:f5:b6:63 brd ff:ff:ff:ff:ff:ff link-netns cni-36d53432-d47d-018a-ee21-8153e8bbd35e

controlplane ~ ➜  #8

controlplane ~ ➜  #9

controlplane ~ ➜  ip route
default via 169.254.1.1 dev eth0 
169.254.1.1 dev eth0 scope link 
172.17.0.0/24 dev cni0 proto kernel scope link src 172.17.0.1 
172.17.1.0/24 via 172.17.1.0 dev flannel.1 onlink 

controlplane ~ ➜  ip route show default
default via 169.254.1.1 dev eth0 

controlplane ~ ➜  # 9 What is the IP address of the Default Gateway?

controlplane ~ ➜  #10

controlplane ~ ➜   netstat -nplt
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name    
tcp        0      0 127.0.0.1:2379          0.0.0.0:*               LISTEN      3245/etcd           
tcp        0      0 127.0.0.1:2381          0.0.0.0:*               LISTEN      3245/etcd           
tcp        0      0 127.0.0.1:33781         0.0.0.0:*               LISTEN      1023/containerd     
tcp        0      0 127.0.0.1:10257         0.0.0.0:*               LISTEN      3219/kube-controlle 
tcp        0      0 127.0.0.1:10259         0.0.0.0:*               LISTEN      3193/kube-scheduler 
tcp        0      0 127.0.0.1:10248         0.0.0.0:*               LISTEN      3821/kubelet        
tcp        0      0 127.0.0.1:10249         0.0.0.0:*               LISTEN      4310/kube-proxy     
tcp        0      0 10.244.213.35:2380      0.0.0.0:*               LISTEN      3245/etcd           
tcp        0      0 10.244.213.35:2379      0.0.0.0:*               LISTEN      3245/etcd           
tcp        0      0 0.0.0.0:8080            0.0.0.0:*               LISTEN      1028/ttyd           
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      1029/sshd: /usr/sbi 
tcp6       0      0 :::6443                 :::*                    LISTEN      3309/kube-apiserver 
tcp6       0      0 :::22                   :::*                    LISTEN      1029/sshd: /usr/sbi 
tcp6       0      0 :::10250                :::*                    LISTEN      3821/kubelet        
tcp6       0      0 :::10256                :::*                    LISTEN      4310/kube-proxy     
tcp6       0      0 :::8888                 :::*                    LISTEN      5310/kubectl        

controlplane ~ ➜  #11

controlplane ~ ➜  ip address show type bridge
6: cni0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1400 qdisc noqueue state UP group default qlen 1000
    link/ether 42:57:e7:48:c8:ee brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/24 brd 172.17.0.255 scope global cni0
       valid_lft forever preferred_lft forever
    inet6 fe80::4057:e7ff:fe48:c8ee/64 scope link 
       valid_lft forever preferred_lft forever

controlplane ~ ➜   netstat -anp | grep etcd
tcp        0      0 127.0.0.1:2379          0.0.0.0:*               LISTEN      3245/etcd           
tcp        0      0 127.0.0.1:2381          0.0.0.0:*               LISTEN      3245/etcd           
tcp        0      0 10.244.213.35:2380      0.0.0.0:*               LISTEN      3245/etcd           
tcp        0      0 10.244.213.35:2379      0.0.0.0:*               LISTEN      3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:40220         ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:40668         ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:40442         ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:39806         ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:39888         ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:40928         ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:40510         ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:39966         ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:39910         ESTABLISHED 3245/etcd           
tcp        0      0 10.244.213.35:60068     10.244.213.35:2379      ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:40114         ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:40486         ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:40234         ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:40170         ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:40468         ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:40424         ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:40746         ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:40820         ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:40518         ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:39972         ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:40010         ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:40822         ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:40342         ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:40690         ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:40094         ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:40538         ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:40882         ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:40404         ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:40368         ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:40868         ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:40312         ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:40278         ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:39858         ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:40330         ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:40922         ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:39920         ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:40150         ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:40158         ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:39828         ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:40002         ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:39830         ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:40378         ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:40848         ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:39944         ESTABLISHED 3245/etcd           
tcp        0      0 10.244.213.35:2379      10.244.213.35:60068     ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:39962         ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:40718         ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:40030         ESTABLISHED 3245/etcd           
tcp        0      0 10.244.213.35:60052     10.244.213.35:2379      ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:40566         ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:40282         ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:40092         ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:40076         ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:40776         ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:40762         ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:40066         ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:40808         ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:40730         ESTABLISHED 3245/etcd           
tcp        0      0 10.244.213.35:2379      10.244.213.35:60052     ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:40598         ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:40758         ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:40428         ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:40588         ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:40608         ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:40636         ESTABLISHED 3245/etcd           
tcp        0      0 127.0.0.1:2379          127.0.0.1:40198         ESTABLISHED 3245/etcd           

controlplane ~ ➜   netstat -anp | grep etcd | grep 2380 | wc -l 
1

controlplane ~ ➜   netstat -anp | grep etcd | grep 2379 | wc -l 
68

controlplane ~ ➜  #12 Correct! That's because 2379 is the port of ETCD to which all control plane components connect to. 2380 is only for etcd peer-to-peer connectivity. When you have multiple controlplane nodes. In this case we don't

controlplane ~ ➜  history
    1  #1
    2  k get nodes -A
    3  #2
    4  k get nodes -A -o wide
    5  #3
    6  ip address | grep -i "controlplane"
    7  ip address
    8  ip address | grep -i "10.244.213.35" -C3
    9  #4
   10  #5
   11  #6
   12  ip address | grep -i "213.63" -C3
   13  k get nodes
   14  k get nodes -o wide
   15  ssh node01
   16  ip link
   17  #8
   18  #9
   19  ip route
   20  ip route show default
   21* # 9 What is the IP address of the Default Gatewa
   22  #10
   23  #11
   24  ip address show type bridge
   25  #12 Correct! That's because 2379 is the port of ETCD to which all control plane components connect to. 2380 is only for etcd peer-to-peer connectivity. When you have multiple controlplane nodes. In this case we don't
   26  history
```

# Explore CNI 
```cmd
         Welcome to the KodeKloud Hands-On lab                                                                                                      
    __ ______  ____  ________ __ __    ____  __  ______ 
   / //_/ __ \/ __ \/ ____/ //_// /   / __ \/ / / / __ \
  / ,< / / / / / / / __/ / ,<  / /   / / / / / / / / / /
 / /| / /_/ / /_/ / /___/ /| |/ /___/ /_/ / /_/ / /_/ / 
/_/ |_\____/_____/_____/_/ |_/_____/\____/\____/_____/  
                                                        
               All rights reserved                                                                                                                  

controlplane ~ ➜  #1

controlplane ~ ➜  k get svc -A
NAMESPACE     NAME         TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)                  AGE
default       kubernetes   ClusterIP   172.20.0.1    <none>        443/TCP                  13m
kube-system   kube-dns     ClusterIP   172.20.0.10   <none>        53/UDP,53/TCP,9153/TCP   13m

controlplane ~ ➜  cat /var/lib/kubelet/config.yaml 
apiVersion: kubelet.config.k8s.io/v1beta1
authentication:
  anonymous:
    enabled: false
  webhook:
    cacheTTL: 0s
    enabled: true
  x509:
    clientCAFile: /etc/kubernetes/pki/ca.crt
authorization:
  mode: Webhook
  webhook:
    cacheAuthorizedTTL: 0s
    cacheUnauthorizedTTL: 0s
cgroupDriver: systemd
clusterDNS:
- 172.20.0.10
clusterDomain: cluster.local
containerRuntimeEndpoint: unix:///var/run/containerd/containerd.sock
cpuManagerReconcilePeriod: 0s
crashLoopBackOff: {}
evictionPressureTransitionPeriod: 0s
fileCheckFrequency: 0s
healthzBindAddress: 127.0.0.1
healthzPort: 10248
httpCheckFrequency: 0s
imageMaximumGCAge: 0s
imageMinimumGCAge: 0s
kind: KubeletConfiguration
logging:
  flushFrequency: 0
  options:
    json:
      infoBufferSize: "0"
    text:
      infoBufferSize: "0"
  verbosity: 0
memorySwap: {}
nodeStatusReportFrequency: 0s
nodeStatusUpdateFrequency: 0s
rotateCertificates: true
runtimeRequestTimeout: 0s
shutdownGracePeriod: 0s
shutdownGracePeriodCriticalPods: 0s
staticPodPath: /etc/kubernetes/manifests
streamingConnectionIdleTimeout: 0s
syncFrequency: 0s
volumeStatsAggPeriod: 0s

controlplane ~ ➜  #2

controlplane ~ ➜  # ^[[200~What is the path configured with all binaries of CNI supported plugins? /opt/cni/bin

controlplane ~ ➜  #3

controlplane ~ ➜  ls /opt/cni/bin
bandwidth  dhcp   firewall  host-device  ipvlan   loopback  portmap  README.md  static  tuning  vrf
bridge     dummy  flannel   host-local   LICENSE  macvlan   ptp      sbr        tap     vlan

controlplane ~ ➜  #4

controlplane ~ ➜  # What is the CNI plugin configured to be used on this kubernetes cluster?

controlplane ~ ➜  ls /etc/cni/net.d/
10-flannel.conflist

controlplane ~ ➜  #5 What binary executable file will be invoked by the container runtime after a container and its associated namespace are created?

controlplane ~ ➜  cat /etc/cni/net.d/10-flannel.conflist 
{
  "name": "cbr0",
  "cniVersion": "0.3.1",
  "plugins": [
    {
      "type": "flannel",
      "delegate": {
        "hairpinMode": true,
        "isDefaultGateway": true
      }
    },
    {
      "type": "portmap",
      "capabilities": {
        "portMappings": true
      }
    }
  ]
}

controlplane ~ ➜  history
    1  #1
    2  k get svc -A
    3  cat /var/lib/kubelet/config.yaml 
    4  #2
    5  # What is the path configured with all binaries of CNI supported plugins? /opt/cni/bin
    6  #3
    7  ls /opt/cni/bin
    8  #4
    9  # What is the CNI plugin configured to be used on this kubernetes cluster?
   10  ls /etc/cni/net.d/
   11  #5 What binary executable file will be invoked by the container runtime after a container and its associated namespace are created?
   12  cat /etc/cni/net.d/10-flannel.conflist 
   13  history
```