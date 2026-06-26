# 

##  Persistent Volume Claims
```cmd

controlplane ~ ➜  #1

controlplane ~ ➜  k get pod 
NAME     READY   STATUS    RESTARTS   AGE
webapp   1/1     Running   0          46s

controlplane ~ ➜  k get pod -n default
NAME     READY   STATUS    RESTARTS   AGE
webapp   1/1     Running   0          54s

controlplane ~ ➜  k get pod -n default -o wide
NAME     READY   STATUS    RESTARTS   AGE   IP           NODE           NOMINATED NODE   READINESS GATES
webapp   1/1     Running   0          58s   172.17.0.4   controlplane   <none>           <none>

controlplane ~ ➜  k get pod -n kube-system 
NAME                                   READY   STATUS    RESTARTS   AGE
coredns-6f6c7df987-kg2nj               1/1     Running   0          9m47s
coredns-6f6c7df987-vm4qc               1/1     Running   0          9m47s
etcd-controlplane                      1/1     Running   0          9m56s
kube-apiserver-controlplane            1/1     Running   0          9m55s
kube-controller-manager-controlplane   1/1     Running   0          9m56s
kube-proxy-lgs87                       1/1     Running   0          9m48s
kube-scheduler-controlplane            1/1     Running   0          9m55s

controlplane ~ ➜  #2

controlplane ~ ➜  k execute webapp -- cat /log/app.log
error: unknown command "execute" for "kubectl"

controlplane ~ ✖ k exec webapp -- cat /log/app.log
[2026-06-26 12:05:35,672] INFO in event-simulator: USER4 logged out
[2026-06-26 12:05:36,672] INFO in event-simulator: USER4 logged in
[2026-06-26 12:05:37,673] INFO in event-simulator: USER2 logged in
[2026-06-26 12:05:38,674] INFO in event-simulator: USER4 logged out
[2026-06-26 12:05:39,675] INFO in event-simulator: USER1 is viewing page2
[2026-06-26 12:05:40,676] WARNING in event-simulator: USER5 Failed to Login as the account is locked due to MANY FAILED ATTEMPTS.
[2026-06-26 12:05:40,676] INFO in event-simulator: USER4 is viewing page1
[2026-06-26 12:05:41,677] INFO in event-simulator: USER1 is viewing page3
[2026-06-26 12:05:42,678] INFO in event-simulator: USER4 is viewing page3
[2026-06-26 12:05:43,679] WARNING in event-simulator: USER7 Order failed as the item is OUT OF STOCK.
[2026-06-26 12:05:43,679] INFO in event-simulator: USER1 is viewing page2
[2026-06-26 12:05:44,680] INFO in event-simulator: USER4 is viewing page1
[2026-06-26 12:05:45,681] WARNING in event-simulator: USER5 Failed to Login as the account is locked due to MANY FAILED ATTEMPTS.
[2026-06-26 12:05:45,681] INFO in event-simulator: USER3 logged in
[2026-06-26 12:05:46,682] INFO in event-simulator: USER4 logged in
[2026-06-26 12:05:47,683] INFO in event-simulator: USER1 logged in
[2026-06-26 12:05:48,684] INFO in event-simulator: USER2 is viewing page1
[2026-06-26 12:05:49,685] INFO in event-simulator: USER3 logged out
[2026-06-26 12:05:50,686] WARNING in event-simulator: USER5 Failed to Login as the account is locked due to MANY FAILED ATTEMPTS.
[2026-06-26 12:05:50,686] INFO in event-simulator: USER3 is viewing page1
[2026-06-26 12:05:51,687] WARNING in event-simulator: USER7 Order failed as the item is OUT OF STOCK.
[2026-06-26 12:05:51,687] INFO in event-simulator: USER3 is viewing page2
[2026-06-26 12:05:52,688] INFO in event-simulator: USER2 logged out
[2026-06-26 12:05:53,689] INFO in event-simulator: USER4 logged in
[2026-06-26 12:05:54,690] INFO in event-simulator: USER1 is viewing page2
[2026-06-26 12:05:55,691] WARNING in event-simulator: USER5 Failed to Login as the account is locked due to MANY FAILED ATTEMPTS.
[2026-06-26 12:05:55,691] INFO in event-simulator: USER1 is viewing page1
[2026-06-26 12:05:56,692] INFO in event-simulator: USER4 is viewing page1
[2026-06-26 12:05:57,693] INFO in event-simulator: USER3 is viewing page3
[2026-06-26 12:05:58,694] INFO in event-simulator: USER3 is viewing page3
[2026-06-26 12:05:59,695] WARNING in event-simulator: USER7 Order failed as the item is OUT OF STOCK.
[2026-06-26 12:05:59,695] INFO in event-simulator: USER4 is viewing page1
[2026-06-26 12:06:00,696] WARNING in event-simulator: USER5 Failed to Login as the account is locked due to MANY FAILED ATTEMPTS.
[2026-06-26 12:06:00,696] INFO in event-simulator: USER2 is viewing page3
[2026-06-26 12:06:01,697] INFO in event-simulator: USER2 is viewing page2
[2026-06-26 12:06:02,698] INFO in event-simulator: USER1 is viewing page3
[2026-06-26 12:06:03,699] INFO in event-simulator: USER3 logged out
[2026-06-26 12:06:04,700] INFO in event-simulator: USER2 is viewing page3
[2026-06-26 12:06:05,701] WARNING in event-simulator: USER5 Failed to Login as the account is locked due to MANY FAILED ATTEMPTS.
[2026-06-26 12:06:05,702] INFO in event-simulator: USER4 logged in
[2026-06-26 12:06:06,702] INFO in event-simulator: USER4 logged in
[2026-06-26 12:06:07,703] WARNING in event-simulator: USER7 Order failed as the item is OUT OF STOCK.
[2026-06-26 12:06:07,703] INFO in event-simulator: USER2 logged out
[2026-06-26 12:06:08,704] INFO in event-simulator: USER4 is viewing page2
[2026-06-26 12:06:09,705] INFO in event-simulator: USER3 logged out
[2026-06-26 12:06:10,706] WARNING in event-simulator: USER5 Failed to Login as the account is locked due to MANY FAILED ATTEMPTS.
[2026-06-26 12:06:10,706] INFO in event-simulator: USER2 is viewing page1
[2026-06-26 12:06:11,707] INFO in event-simulator: USER3 is viewing page1
[2026-06-26 12:06:12,708] INFO in event-simulator: USER2 is viewing page1
[2026-06-26 12:06:13,709] INFO in event-simulator: USER1 logged in
[2026-06-26 12:06:14,710] INFO in event-simulator: USER2 logged out
[2026-06-26 12:06:15,711] WARNING in event-simulator: USER5 Failed to Login as the account is locked due to MANY FAILED ATTEMPTS.
[2026-06-26 12:06:15,711] WARNING in event-simulator: USER7 Order failed as the item is OUT OF STOCK.
[2026-06-26 12:06:15,711] INFO in event-simulator: USER4 logged in
[2026-06-26 12:06:16,712] INFO in event-simulator: USER4 logged out
[2026-06-26 12:06:17,713] INFO in event-simulator: USER2 is viewing page1
[2026-06-26 12:06:18,714] INFO in event-simulator: USER2 logged in
[2026-06-26 12:06:19,715] INFO in event-simulator: USER1 is viewing page3
[2026-06-26 12:06:20,716] WARNING in event-simulator: USER5 Failed to Login as the account is locked due to MANY FAILED ATTEMPTS.
[2026-06-26 12:06:20,716] INFO in event-simulator: USER3 logged out
[2026-06-26 12:06:21,717] INFO in event-simulator: USER3 is viewing page2
[2026-06-26 12:06:22,718] INFO in event-simulator: USER3 is viewing page1
[2026-06-26 12:06:23,719] WARNING in event-simulator: USER7 Order failed as the item is OUT OF STOCK.
[2026-06-26 12:06:23,719] INFO in event-simulator: USER1 is viewing page3
[2026-06-26 12:06:24,720] INFO in event-simulator: USER2 is viewing page1
[2026-06-26 12:06:25,721] WARNING in event-simulator: USER5 Failed to Login as the account is locked due to MANY FAILED ATTEMPTS.
[2026-06-26 12:06:25,721] INFO in event-simulator: USER4 logged out
[2026-06-26 12:06:26,722] INFO in event-simulator: USER1 logged in
[2026-06-26 12:06:27,723] INFO in event-simulator: USER4 is viewing page3
[2026-06-26 12:06:28,724] INFO in event-simulator: USER4 is viewing page2
[2026-06-26 12:06:29,725] INFO in event-simulator: USER2 is viewing page3
[2026-06-26 12:06:30,726] WARNING in event-simulator: USER5 Failed to Login as the account is locked due to MANY FAILED ATTEMPTS.
[2026-06-26 12:06:30,726] INFO in event-simulator: USER4 is viewing page1
[2026-06-26 12:06:31,727] WARNING in event-simulator: USER7 Order failed as the item is OUT OF STOCK.
[2026-06-26 12:06:31,727] INFO in event-simulator: USER3 is viewing page1
[2026-06-26 12:06:32,728] INFO in event-simulator: USER3 logged in
[2026-06-26 12:06:33,729] INFO in event-simulator: USER4 is viewing page1
[2026-06-26 12:06:34,730] INFO in event-simulator: USER3 is viewing page2
[2026-06-26 12:06:35,731] WARNING in event-simulator: USER5 Failed to Login as the account is locked due to MANY FAILED ATTEMPTS.
[2026-06-26 12:06:35,731] INFO in event-simulator: USER1 logged in
[2026-06-26 12:06:36,732] INFO in event-simulator: USER2 logged out
[2026-06-26 12:06:37,733] INFO in event-simulator: USER3 logged out
[2026-06-26 12:06:38,734] INFO in event-simulator: USER4 logged in
[2026-06-26 12:06:39,735] WARNING in event-simulator: USER7 Order failed as the item is OUT OF STOCK.
[2026-06-26 12:06:39,735] INFO in event-simulator: USER3 is viewing page3
[2026-06-26 12:06:40,736] WARNING in event-simulator: USER5 Failed to Login as the account is locked due to MANY FAILED ATTEMPTS.
[2026-06-26 12:06:40,737] INFO in event-simulator: USER2 is viewing page3
[2026-06-26 12:06:41,738] INFO in event-simulator: USER3 is viewing page3
[2026-06-26 12:06:42,738] INFO in event-simulator: USER2 logged out
[2026-06-26 12:06:43,739] INFO in event-simulator: USER3 is viewing page1
[2026-06-26 12:06:44,741] INFO in event-simulator: USER1 logged out
[2026-06-26 12:06:45,741] WARNING in event-simulator: USER5 Failed to Login as the account is locked due to MANY FAILED ATTEMPTS.
[2026-06-26 12:06:45,741] INFO in event-simulator: USER1 logged in
[2026-06-26 12:06:46,742] INFO in event-simulator: USER2 is viewing page1
[2026-06-26 12:06:47,743] WARNING in event-simulator: USER7 Order failed as the item is OUT OF STOCK.
[2026-06-26 12:06:47,743] INFO in event-simulator: USER3 is viewing page3
[2026-06-26 12:06:48,744] INFO in event-simulator: USER3 is viewing page2
[2026-06-26 12:06:49,745] INFO in event-simulator: USER2 is viewing page1
[2026-06-26 12:06:50,746] WARNING in event-simulator: USER5 Failed to Login as the account is locked due to MANY FAILED ATTEMPTS.
[2026-06-26 12:06:50,746] INFO in event-simulator: USER1 is viewing page1
[2026-06-26 12:06:51,747] INFO in event-simulator: USER4 logged in
[2026-06-26 12:06:52,748] INFO in event-simulator: USER2 is viewing page3
[2026-06-26 12:06:53,749] INFO in event-simulator: USER3 logged in
[2026-06-26 12:06:54,750] INFO in event-simulator: USER3 is viewing page3
[2026-06-26 12:06:55,751] WARNING in event-simulator: USER5 Failed to Login as the account is locked due to MANY FAILED ATTEMPTS.
[2026-06-26 12:06:55,751] WARNING in event-simulator: USER7 Order failed as the item is OUT OF STOCK.
[2026-06-26 12:06:55,751] INFO in event-simulator: USER1 is viewing page2
[2026-06-26 12:06:56,752] INFO in event-simulator: USER1 is viewing page1
[2026-06-26 12:06:57,753] INFO in event-simulator: USER3 is viewing page3
[2026-06-26 12:06:58,754] INFO in event-simulator: USER2 logged in
[2026-06-26 12:06:59,755] INFO in event-simulator: USER3 is viewing page1
[2026-06-26 12:07:00,756] WARNING in event-simulator: USER5 Failed to Login as the account is locked due to MANY FAILED ATTEMPTS.
[2026-06-26 12:07:00,756] INFO in event-simulator: USER4 is viewing page2
[2026-06-26 12:07:01,757] INFO in event-simulator: USER3 is viewing page1
[2026-06-26 12:07:02,758] INFO in event-simulator: USER3 is viewing page3
[2026-06-26 12:07:03,759] WARNING in event-simulator: USER7 Order failed as the item is OUT OF STOCK.
[2026-06-26 12:07:03,759] INFO in event-simulator: USER4 is viewing page2
[2026-06-26 12:07:04,760] INFO in event-simulator: USER2 is viewing page2
[2026-06-26 12:07:05,761] WARNING in event-simulator: USER5 Failed to Login as the account is locked due to MANY FAILED ATTEMPTS.
[2026-06-26 12:07:05,761] INFO in event-simulator: USER1 logged in
[2026-06-26 12:07:06,762] INFO in event-simulator: USER4 is viewing page1
[2026-06-26 12:07:07,763] INFO in event-simulator: USER2 logged in
[2026-06-26 12:07:08,764] INFO in event-simulator: USER3 is viewing page2
[2026-06-26 12:07:09,765] INFO in event-simulator: USER4 is viewing page3
[2026-06-26 12:07:10,767] WARNING in event-simulator: USER5 Failed to Login as the account is locked due to MANY FAILED ATTEMPTS.
[2026-06-26 12:07:10,767] INFO in event-simulator: USER1 is viewing page2
[2026-06-26 12:07:11,767] WARNING in event-simulator: USER7 Order failed as the item is OUT OF STOCK.
[2026-06-26 12:07:11,767] INFO in event-simulator: USER1 is viewing page1
[2026-06-26 12:07:12,768] INFO in event-simulator: USER4 logged out
[2026-06-26 12:07:13,769] INFO in event-simulator: USER1 is viewing page1
[2026-06-26 12:07:14,770] INFO in event-simulator: USER4 is viewing page2
[2026-06-26 12:07:15,771] WARNING in event-simulator: USER5 Failed to Login as the account is locked due to MANY FAILED ATTEMPTS.
[2026-06-26 12:07:15,771] INFO in event-simulator: USER1 is viewing page3
[2026-06-26 12:07:16,772] INFO in event-simulator: USER1 is viewing page2
[2026-06-26 12:07:17,773] INFO in event-simulator: USER2 is viewing page1
[2026-06-26 12:07:18,774] INFO in event-simulator: USER4 logged out
[2026-06-26 12:07:19,775] WARNING in event-simulator: USER7 Order failed as the item is OUT OF STOCK.
[2026-06-26 12:07:19,775] INFO in event-simulator: USER3 is viewing page1
[2026-06-26 12:07:20,776] WARNING in event-simulator: USER5 Failed to Login as the account is locked due to MANY FAILED ATTEMPTS.
[2026-06-26 12:07:20,776] INFO in event-simulator: USER1 logged out
[2026-06-26 12:07:21,777] INFO in event-simulator: USER3 logged out
[2026-06-26 12:07:22,778] INFO in event-simulator: USER1 is viewing page1
[2026-06-26 12:07:23,779] INFO in event-simulator: USER4 is viewing page1
[2026-06-26 12:07:24,780] INFO in event-simulator: USER1 logged in
[2026-06-26 12:07:25,781] WARNING in event-simulator: USER5 Failed to Login as the account is locked due to MANY FAILED ATTEMPTS.
[2026-06-26 12:07:25,781] INFO in event-simulator: USER3 is viewing page2
[2026-06-26 12:07:26,782] INFO in event-simulator: USER4 is viewing page3

controlplane ~ ➜  k exec --help
Execute a command in a container.

Examples:
  # Get output from running the 'date' command from pod mypod, using the first container by default
  kubectl exec mypod -- date
  
  # Get output from running the 'date' command in ruby-container from pod mypod
  kubectl exec mypod -c ruby-container -- date
  
  # Switch to raw terminal mode; sends stdin to 'bash' in ruby-container from pod mypod
  # and sends stdout/stderr from 'bash' back to the client
  kubectl exec mypod -c ruby-container -i -t -- bash -il
  
  # List contents of /usr from the first container of pod mypod and sort by modification time
  # If the command you want to execute in the pod has any flags in common (e.g. -i),
  # you must use two dashes (--) to separate your command's flags/arguments
  # Also note, do not surround your command and its flags/arguments with quotes
  # unless that is how you would execute it normally (i.e., do ls -t /usr, not "ls -t /usr")
  kubectl exec mypod -i -t -- ls -t /usr
  
  # Get output from running 'date' command from the first pod of the deployment mydeployment, using the first container
by default
  kubectl exec deploy/mydeployment -- date
  
  # Get output from running 'date' command from the first pod of the service myservice, using the first container by
default
  kubectl exec svc/myservice -- date

Options:
    -c, --container='':
        Container name. If omitted, use the kubectl.kubernetes.io/default-container annotation for selecting the
        container to be attached or the first container in the pod will be chosen

    -f, --filename=[]:
        to use to exec into the resource

    --pod-running-timeout=1m0s:
        The length of time (like 5s, 2m, or 3h, higher than zero) to wait until at least one pod is running

    -q, --quiet=false:
        Only print output from the remote session

    -i, --stdin=false:
        Pass stdin to the container

    -t, --tty=false:
        Stdin is a TTY

Usage:
  kubectl exec (POD | TYPE/NAME) [-c CONTAINER] [flags] -- COMMAND [args...] [options]

Use "kubectl options" for a list of global command-line options (applies to all commands).

controlplane ~ ➜  #3

controlplane ~ ➜  #4

controlplane ~ ➜  k edit pod webapp 
error: pods "webapp" is invalid
A copy of your changes has been stored to "/tmp/kubectl-edit-3683185395.yaml"
error: Edit cancelled, no valid changes were saved.

controlplane ~ ✖ ^C

controlplane ~ ✖ k replace --force -f /tmp/kubectl-edit-3683185395.yaml
error: error parsing /tmp/kubectl-edit-3683185395.yaml: error converting YAML to JSON: yaml: line 51: did not find expected '-' indicator

controlplane ~ ✖ vi /tmp/kubectl-edit-3683185395.yaml

controlplane ~ ➜  vi /tmp/kubectl-edit-3683185395.yaml

controlplane ~ ➜  k replace --force -f /tmp/kubectl-edit-3683185395.yaml
error: error parsing /tmp/kubectl-edit-3683185395.yaml: error converting YAML to JSON: yaml: line 54: did not find expected key

controlplane ~ ✖ 

controlplane ~ ✖ vi /tmp/kubectl-edit-3683185395.yaml

controlplane ~ ➜  k replace --force -f /tmp/kubectl-edit-3683185395.yaml
error: error parsing /tmp/kubectl-edit-3683185395.yaml: error converting YAML to JSON: yaml: line 52: mapping values are not allowed in this context

controlplane ~ ✖ vi /tmp/kubectl-edit-3683185395.yaml

controlplane ~ ➜  k replace --force -f /tmp/kubectl-edit-3683185395.yaml
pod "webapp" deleted from default namespace
The Pod "webapp" is invalid: 
* spec.containers[0].volumeMounts[0].name: Required value
* spec.containers[0].volumeMounts[0].name: Not found: ""

controlplane ~ ✖ vi /tmp/kubectl-edit-3683185395.yaml

controlplane ~ ➜  k create -f /tmp/kubectl-edit-3683185395.yaml
pod/webapp created

controlplane ~ ➜  cat /tmp/kubectl-edit-3683185395.yaml | grep -i "volume" -C3
    resources: {}
    terminationMessagePath: /dev/termination-log
    terminationMessagePolicy: File
    volumeMounts:
    - mountPath: /log
      name: webapp
  dnsPolicy: ClusterFirst
--
    key: node.kubernetes.io/unreachable
    operator: Exists
    tolerationSeconds: 300
  volumes:
  - name: webapp
    hostPath:
      path: /var/log/webapp # directory location on host
--
    state:
      running:
        startedAt: "2026-06-26T12:05:35Z"
    volumeMounts:
    - mountPath: /var/run/secrets/kubernetes.io/serviceaccount
      name: kube-api-access-6lrp5
      readOnly: true

controlplane ~ ➜  #5

controlplane ~ ➜  vi 5.yaml

controlplane ~ ➜  k create -f 5.yaml 
persistentvolume/pv-log created

controlplane ~ ➜  cat 5.yaml 
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-log
spec:
  capacity:
    storage: 100Mi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteMany
  persistentVolumeReclaimPolicy: Retain 
  hostPath:
      path: /pv/log

controlplane ~ ➜  #6

controlplane ~ ➜  vi 6.yaml

controlplane ~ ➜  k create -f 6.yaml 
persistentvolumeclaim/claim-log-1 created

controlplane ~ ➜  k get pv -n default 
NAME     CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM   STORAGECLASS   VOLUMEATTRIBUTESCLASS   REASON   AGE
pv-log   100Mi      RWX            Retain           Available                          <unset>                          95s

controlplane ~ ➜  k get pvc -n default 
NAME          STATUS    VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
claim-log-1   Pending                                      manual         <unset>                 17s

controlplane ~ ➜  k get pvc -n default --showlabels
error: unknown flag: --showlabels
See 'kubectl get --help' for usage.

controlplane ~ ✖ k get pvc -n default --show-labels
NAME          STATUS    VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE   LABELS
claim-log-1   Pending                                      manual         <unset>                 27s   <none>

controlplane ~ ➜  #7

controlplane ~ ➜  #8

controlplane ~ ➜  #9

controlplane ~ ➜  #10

controlplane ~ ➜  vi 6.yaml 

controlplane ~ ➜  k replace --force -f 6.yaml 
persistentvolumeclaim "claim-log-1" deleted from default namespace
persistentvolumeclaim/claim-log-1 replaced

controlplane ~ ➜  k get pvc -n default --show-labels
NAME          STATUS    VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE   LABELS
claim-log-1   Pending                                      manual         <unset>                 7s    <none>

controlplane ~ ➜  k get pvc -n default --show-labels
NAME          STATUS    VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE   LABELS
claim-log-1   Pending                                      manual         <unset>                 14s   <none>

controlplane ~ ➜  vi 5.yaml 

controlplane ~ ➜  k get pvc -n default --show-labels
NAME          STATUS    VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE   LABELS
claim-log-1   Pending                                      manual         <unset>                 34s   <none>

controlplane ~ ➜  

controlplane ~ ➜  k get pv -n default 
NAME     CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM   STORAGECLASS   VOLUMEATTRIBUTESCLASS   REASON   AGE
pv-log   100Mi      RWX            Retain           Available                          <unset>                          4m8s

controlplane ~ ➜  vi 6.yaml 

controlplane ~ ➜  vi 5.yaml 

controlplane ~ ➜  vi 6.yaml 

controlplane ~ ➜  vi 5.yaml 

controlplane ~ ➜  vi 6.yaml 

controlplane ~ ➜  k replace --force -f 6.yaml 
persistentvolumeclaim "claim-log-1" deleted from default namespace
persistentvolumeclaim/claim-log-1 replaced

controlplane ~ ➜  k get pvc -n default
NAME          STATUS   VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
claim-log-1   Bound    pv-log   100Mi      RWX                           <unset>                 5s

controlplane ~ ➜  #11

controlplane ~ ➜  vi 6.yaml 

controlplane ~ ➜  #12

controlplane ~ ➜  k edit pod webapp 
error: pods "webapp" is invalid
A copy of your changes has been stored to "/tmp/kubectl-edit-361529526.yaml"
error: Edit cancelled, no valid changes were saved.

controlplane ~ ✖ ^C

controlplane ~ ✖ k replace --force -f /tmp/kubectl-edit-361529526.yaml
pod "webapp" deleted from default namespace
pod/webapp replaced

controlplane ~ ➜  #13

controlplane ~ ➜  k describe pv pv-log 
Name:            pv-log
Labels:          <none>
Annotations:     pv.kubernetes.io/bound-by-controller: yes
Finalizers:      [kubernetes.io/pv-protection]
StorageClass:    
Status:          Bound
Claim:           default/claim-log-1
Reclaim Policy:  Retain
Access Modes:    RWX
VolumeMode:      Filesystem
Capacity:        100Mi
Node Affinity:   <none>
Message:         
Source:
    Type:          HostPath (bare host directory volume)
    Path:          /pv/log
    HostPathType:  
Events:            <none>

controlplane ~ ➜  #14

controlplane ~ ➜  #15

controlplane ~ ➜  k delete pvc claim-log-1 
persistentvolumeclaim "claim-log-1" deleted from default namespace
^C
controlplane ~ ✖ #16

controlplane ~ ✖ k delete pod webapp 
pod "webapp" deleted from default namespace
^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[[D^[      
controlplane ~ ➜  #18

controlplane ~ ➜  #19

controlplane ~ ➜  history
    1  clear
    2  #1
    3  k get pod 
    4  k get pod -n default
    5  k get pod -n default -o wide
    6  k get pod -n kube-system 
    7  #2
    8  k execute webapp -- cat /log/app.log
    9  k exec webapp -- cat /log/app.log
   10  k exec --help
   11  #3
   12  #4
   13  k edit pod webapp 
   14  k replace --force -f /tmp/kubectl-edit-3683185395.yaml
   15  vi /tmp/kubectl-edit-3683185395.yaml
   16  k replace --force -f /tmp/kubectl-edit-3683185395.yaml
   17  vi /tmp/kubectl-edit-3683185395.yaml
   18  k replace --force -f /tmp/kubectl-edit-3683185395.yaml
   19  vi /tmp/kubectl-edit-3683185395.yaml
   20  k replace --force -f /tmp/kubectl-edit-3683185395.yaml
   21  vi /tmp/kubectl-edit-3683185395.yaml
   22  k create -f /tmp/kubectl-edit-3683185395.yaml
   23  cat /tmp/kubectl-edit-3683185395.yaml | grep -i "volume" -C3
   24  #5
   25  vi 5.yaml
   26  k create -f 5.yaml 
   27  cat 5.yaml 
   28  #6
   29  vi 6.yaml
   30  k create -f 6.yaml 
   31  k get pv -n default 
   32  k get pvc -n default 
   33  k get pvc -n default --showlabels
   34  k get pvc -n default --show-labels
   35  #7
   36  #8
   37  #9
   38  #10
   39  vi 6.yaml 
   40  k replace --force -f 6.yaml 
   41  k get pvc -n default --show-labels
   42  vi 5.yaml 
   43  k get pvc -n default --show-labels
   44  k get pv -n default 
   45  vi 6.yaml 
   46  vi 5.yaml 
   47  vi 6.yaml 
   48  vi 5.yaml 
   49  vi 6.yaml 
   50  k replace --force -f 6.yaml 
   51  k get pvc -n default
   52  #11
   53  vi 6.yaml 
   54  #12
   55  k edit pod webapp 
   56  k replace --force -f /tmp/kubectl-edit-361529526.yaml
   57  #13
   58  k describe pv pv-log 
   59  #14
   60  #15
   61  k delete pvc claim-log-1 
   62  #16
   63  k delete pod webapp 
   64  #18
   65  #19
   66  history
```

## Storage Class
```cmd
         Welcome to the KodeKloud Hands-On lab                                                                                                      
    __ ______  ____  ________ __ __    ____  __  ______ 
   / //_/ __ \/ __ \/ ____/ //_// /   / __ \/ / / / __ \
  / ,< / / / / / / / __/ / ,<  / /   / / / / / / / / / /
 / /| / /_/ / /_/ / /___/ /| |/ /___/ /_/ / /_/ / /_/ / 
/_/ |_\____/_____/_____/_/ |_/_____/\____/\____/_____/  
                                                        
               All rights reserved                                                                                                                  

controlplane ~ ➜  #1

controlplane ~ ➜  k get storageclasses.storage.k8s.io 
NAME                   PROVISIONER             RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
local-path (default)   rancher.io/local-path   Delete          WaitForFirstConsumer   false                  6m6s

controlplane ~ ➜  k get sc
NAME                   PROVISIONER             RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
local-path (default)   rancher.io/local-path   Delete          WaitForFirstConsumer   false                  6m12s

controlplane ~ ➜  #2

controlplane ~ ➜  k get sc
NAME                        PROVISIONER                     RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
local-path (default)        rancher.io/local-path           Delete          WaitForFirstConsumer   false                  6m31s
local-storage               kubernetes.io/no-provisioner    Delete          WaitForFirstConsumer   false                  14s
portworx-io-priority-high   kubernetes.io/portworx-volume   Delete          Immediate              false                  14s

controlplane ~ ➜  #3

controlplane ~ ➜  #4

controlplane ~ ➜  #5

controlplane ~ ➜  ^C

controlplane ~ ✖ k describe sc portworx-io-priority-high 
Name:            portworx-io-priority-high
IsDefaultClass:  No
Annotations:     kubectl.kubernetes.io/last-applied-configuration={"apiVersion":"storage.k8s.io/v1","kind":"StorageClass","metadata":{"annotations":{},"name":"portworx-io-priority-high"},"parameters":{"priority_io":"high","repl":"1","snap_interval":"70"},"provisioner":"kubernetes.io/portworx-volume"}

Provisioner:           kubernetes.io/portworx-volume
Parameters:            priority_io=high,repl=1,snap_interval=70
AllowVolumeExpansion:  <unset>
MountOptions:          <none>
ReclaimPolicy:         Delete
VolumeBindingMode:     Immediate
Events:                <none>

controlplane ~ ➜  #6

controlplane ~ ➜  vi 6.yaml

controlplane ~ ➜  k create -f 6.yaml 
persistentvolumeclaim/local-pvc created

controlplane ~ ➜  vi 6.yaml

controlplane ~ ➜  k replace --force -f 6.yaml 
persistentvolumeclaim "local-pvc" deleted from default namespace
persistentvolumeclaim/local-pvc replaced

controlplane ~ ➜  #7

controlplane ~ ➜  k get pvc -n default
NAME        STATUS    VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
local-pvc   Pending                                      local-path     <unset>                 16s

controlplane ~ ➜  #8

controlplane ~ ➜  k describe pvc local-pvc 
Name:          local-pvc
Namespace:     default
StorageClass:  local-path
Status:        Pending
Volume:        
Labels:        <none>
Annotations:   <none>
Finalizers:    [kubernetes.io/pvc-protection]
Capacity:      
Access Modes:  
VolumeMode:    Filesystem
Used By:       <none>
Events:
  Type    Reason                Age               From                         Message
  ----    ------                ----              ----                         -------
  Normal  WaitForFirstConsumer  4s (x4 over 41s)  persistentvolume-controller  waiting for first consumer to be created before binding

controlplane ~ ➜  #9

controlplane ~ ➜  #10

controlplane ~ ➜  k run nginx --image=nginx:alpine --dry-run=client -oyaml > 10.yaml

controlplane ~ ➜  vi 10.yaml 

controlplane ~ ➜  k create -f 10.yaml 
pod/nginx created

controlplane ~ ➜  #11

controlplane ~ ➜  vi 11.yaml

controlplane ~ ➜  k create -f 11.yaml 
storageclass.storage.k8s.io/delayed-volume-sc created

controlplane ~ ➜  history
    1  #1
    2  k get storageclasses.storage.k8s.io 
    3  k get sc
    4  #2
    5  k get sc
    6  #3
    7  #4
    8  #5
    9  k describe sc portworx-io-priority-high 
   10  #6
   11  vi 6.yaml
   12  k create -f 6.yaml 
   13  vi 6.yaml
   14  k replace --force -f 6.yaml 
   15  #7
   16  k get pvc -n default
   17  #8
   18  k describe pvc local-pvc 
   19  #9
   20  #10
   21  k run nginx --image=nginx:alpine --dry-run=client -oyaml > 10.yaml
   22  vi 10.yaml 
   23  k create -f 10.yaml 
   24  #11
   25  vi 11.yaml
   26  k create -f 11.yaml 
   27  history
```