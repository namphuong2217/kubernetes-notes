# Rolling Updates and Rollbacks
```cmd
          Welcome to the KodeKloud Hands-On lab                                                                                                                      
    __ ______  ____  ________ __ __    ____  __  ______ 
   / //_/ __ \/ __ \/ ____/ //_// /   / __ \/ / / / __ \
  / ,< / / / / / / / __/ / ,<  / /   / / / / / / / / / /
 / /| / /_/ / /_/ / /___/ /| |/ /___/ /_/ / /_/ / /_/ / 
/_/ |_\____/_____/_____/_/ |_/_____/\____/\____/_____/  
                                                        
                 All rights reserved                                                                                                                                 

controlplane ~ ➜  #1

controlplane ~ ➜  k get pod
NAME                        READY   STATUS    RESTARTS   AGE
frontend-59dfbc6688-2h89s   1/1     Running   0          23s
frontend-59dfbc6688-k9gl7   1/1     Running   0          23s
frontend-59dfbc6688-r9m57   1/1     Running   0          23s
frontend-59dfbc6688-tlwbt   1/1     Running   0          23s

controlplane ~ ➜  k get svc
NAME             TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
kubernetes       ClusterIP   10.43.0.1       <none>        443/TCP          5m54s
webapp-service   NodePort    10.43.159.233   <none>        8080:30080/TCP   28s

controlplane ~ ➜  #1

controlplane ~ ➜  ls
curl-pod.yaml  curl-test.sh

controlplane ~ ➜  bash /root/curl-test.sh
Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK


controlplane ~ ➜  #2,3

controlplane ~ ➜  #4

controlplane ~ ➜  k get deploy
NAME       READY   UP-TO-DATE   AVAILABLE   AGE
frontend   4/4     4            4           91s

controlplane ~ ➜  k describe deploy frontend
Name:                   frontend
Namespace:              default
CreationTimestamp:      Tue, 09 Jun 2026 10:11:14 +0000
Labels:                 <none>
Annotations:            deployment.kubernetes.io/revision: 1
Selector:               name=webapp
Replicas:               4 desired | 4 updated | 4 total | 4 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        20
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  name=webapp
  Containers:
   simple-webapp:
    Image:         kodekloud/webapp-color:v1
    Port:          8080/TCP
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
NewReplicaSet:   frontend-59dfbc6688 (4/4 replicas created)
Events:
  Type    Reason             Age   From                   Message
  ----    ------             ----  ----                   -------
  Normal  ScalingReplicaSet  108s  deployment-controller  Scaled up replica set frontend-59dfbc6688 from 0 to 4

controlplane ~ ➜  #5

controlplane ~ ➜  #6

controlplane ~ ➜  #7

controlplane ~ ➜  #8

controlplane ~ ➜  k edit deploy frontend --image=kodekloud/webapp-color:v2
error: unknown flag: --image
See 'kubectl edit --help' for usage.

controlplane ~ ✖ k edit deploy frontend --help
Edit a resource from the default editor.

 The edit command allows you to directly edit any API resource you can retrieve via the command-line tools. It will open
the editor defined by your KUBE_EDITOR, or EDITOR environment variables, or fall back to 'vi' for Linux or 'notepad' for
Windows. When attempting to open the editor, it will first attempt to use the shell that has been defined in the 'SHELL'
environment variable. If this is not defined, the default shell will be used, which is '/bin/bash' for Linux or 'cmd'
for Windows.

 You can edit multiple objects, although changes are applied one at a time. The command accepts file names as well as
command-line arguments, although the files you point to must be previously saved versions of resources.

 Editing is done with the API version used to fetch the resource. To edit using a specific API version, fully-qualify
the resource, version, and group.

 The default format is YAML. To edit in JSON, specify "-o json".

 The flag --windows-line-endings can be used to force Windows line endings, otherwise the default for your operating
system will be used.

 In the event an error occurs while updating, a temporary file will be created on disk that contains your unapplied
changes. The most common error when updating a resource is another editor changing the resource on the server. When this
occurs, you will have to apply your changes to the newer version of the resource, or update your temporary saved copy to
include the latest resource version.

Examples:
  # Edit the service named 'registry'
  kubectl edit svc/registry
  
  # Use an alternative editor
  KUBE_EDITOR="nano" kubectl edit svc/registry
  
  # Edit the job 'myjob' in JSON using the v1 API format
  kubectl edit job.v1.batch/myjob -o json
  
  # Edit the deployment 'mydeployment' in YAML and save the modified config in its annotation
  kubectl edit deployment/mydeployment -o yaml --save-config
  
  # Edit the 'status' subresource for the 'mydeployment' deployment
  kubectl edit deployment mydeployment --subresource='status'

Options:
    --allow-missing-template-keys=true:
        If true, ignore any errors in templates when a field or map key is missing in the template. Only applies to
        golang and jsonpath output formats.

    --field-manager='kubectl-edit':
        Name of the manager used to track field ownership.

    -f, --filename=[]:
        Filename, directory, or URL to files to use to edit the resource

    -k, --kustomize='':
        Process the kustomization directory. This flag can't be used together with -f or -R.

    -o, --output='':
        Output format. One of: (json, yaml, kyaml, name, go-template, go-template-file, template, templatefile,
        jsonpath, jsonpath-as-json, jsonpath-file).

    --output-patch=false:
        Output the patch if the resource is edited.

    -R, --recursive=false:
        Process the directory used in -f, --filename recursively. Useful when you want to manage related manifests
        organized within the same directory.

    --save-config=false:
        If true, the configuration of current object will be saved in its annotation. Otherwise, the annotation will
        be unchanged. This flag is useful when you want to perform kubectl apply on this object in the future.

    --show-managed-fields=false:
        If true, keep the managedFields when printing objects in JSON or YAML format.

    --subresource='':
        If specified, edit will operate on the subresource of the requested object.

    --template='':
        Template string or path to template file to use when -o=go-template, -o=go-template-file. The template format
        is golang templates [http://golang.org/pkg/text/template/#pkg-overview].

    --validate='strict':
        Must be one of: strict (or true), warn, ignore (or false). "true" or "strict" will use a schema to validate
        the input and fail the request if invalid. It will perform server side validation if ServerSideFieldValidation
        is enabled on the api-server, but will fall back to less reliable client-side validation if not. "warn" will
        warn about unknown or duplicate fields without blocking the request if server-side field validation is enabled
        on the API server, and behave as "ignore" otherwise. "false" or "ignore" will not perform any schema
        validation, silently dropping any unknown or duplicate fields.

    --windows-line-endings=false:
        Defaults to the line ending native to your platform.

Usage:
  kubectl edit (RESOURCE/NAME | -f FILENAME) [options]

Use "kubectl options" for a list of global command-line options (applies to all commands).

controlplane ~ ➜  k edit deploy frontend
deployment.apps/frontend edited

controlplane ~ ➜  k describe deploy frontend 
Name:                   frontend
Namespace:              default
CreationTimestamp:      Tue, 09 Jun 2026 10:11:14 +0000
Labels:                 <none>
Annotations:            deployment.kubernetes.io/revision: 2
Selector:               name=webapp
Replicas:               4 desired | 2 updated | 5 total | 3 available | 2 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        20
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  name=webapp
  Containers:
   simple-webapp:
    Image:         kodekloud/webapp-color:v2
    Port:          8080/TCP
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
  Progressing    True    ReplicaSetUpdated
OldReplicaSets:  frontend-59dfbc6688 (3/3 replicas created)
NewReplicaSet:   frontend-799cddccfc (2/2 replicas created)
Events:
  Type    Reason             Age    From                   Message
  ----    ------             ----   ----                   -------
  Normal  ScalingReplicaSet  4m49s  deployment-controller  Scaled up replica set frontend-59dfbc6688 from 0 to 4
  Normal  ScalingReplicaSet  17s    deployment-controller  Scaled up replica set frontend-799cddccfc from 0 to 1
  Normal  ScalingReplicaSet  17s    deployment-controller  Scaled down replica set frontend-59dfbc6688 from 4 to 3
  Normal  ScalingReplicaSet  17s    deployment-controller  Scaled up replica set frontend-799cddccfc from 1 to 2

controlplane ~ ➜  #9

controlplane ~ ➜  bash /root/curl-test.sh
Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK


controlplane ~ ➜  #10

controlplane ~ ➜  #11

controlplane ~ ➜  k edit deploy frontend
deployment.apps/frontend edited

controlplane ~ ➜  #12

controlplane ~ ➜  k edit deploy frontend
deployment.apps/frontend edited

controlplane ~ ➜  #13

controlplane ~ ➜  bash /root/curl-test.sh
Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK


controlplane ~ ➜  history
    1  #1
    2  k get pod
    3  k get svc
    4  #1
    5  ls
    6  bash /root/curl-test.sh
    7  #2,3
    8  #4
    9  k get deploy
   10  k describe deploy frontend
   11  #5
   12  #6
   13  #7
   14  #8
   15  k edit deploy frontend --image=kodekloud/webapp-color:v2
   16  k edit deploy frontend --help
   17  k edit deploy frontend
   18  k describe deploy frontend 
   19  #9
   20  bash /root/curl-test.sh
   21  #10
   22  #11
   23  k edit deploy frontend
   24  #12
   25  k edit deploy frontend
   26  #13
   27  bash /root/curl-test.sh
   28  history

```

# Commands Arguments
```cmd
            Welcome to the KodeKloud Hands-On lab                                                                                                                                          
    __ ______  ____  ________ __ __    ____  __  ______ 
   / //_/ __ \/ __ \/ ____/ //_// /   / __ \/ / / / __ \
  / ,< / / / / / / / __/ / ,<  / /   / / / / / / / / / /
 / /| / /_/ / /_/ / /___/ /| |/ /___/ /_/ / /_/ / /_/ / 
/_/ |_\____/_____/_____/_/ |_/_____/\____/\____/_____/  
                                                        
                   All rights reserved                                                                                                                                                     

controlplane ~ ➜  #1

controlplane ~ ➜  k get pod
NAME             READY   STATUS    RESTARTS   AGE
ubuntu-sleeper   1/1     Running   0          8s

controlplane ~ ➜  #2

controlplane ~ ➜  k describe pod ubuntu-sleeper 
Name:             ubuntu-sleeper
Namespace:        default
Priority:         0
Service Account:  default
Node:             controlplane/10.244.220.230
Start Time:       Tue, 09 Jun 2026 10:22:07 +0000
Labels:           <none>
Annotations:      <none>
Status:           Running
IP:               10.22.0.9
IPs:
  IP:  10.22.0.9
Containers:
  ubuntu:
    Container ID:  containerd://4539a1b2430aac120ecfa1b6cbeb7ea5c3636a8fb4e677dccd6aa0e372d98430
    Image:         ubuntu
    Image ID:      docker.io/library/ubuntu@sha256:f3d28607ddd78734bb7f71f117f3c6706c666b8b76cbff7c9ff6e5718d46ff64
    Port:          <none>
    Host Port:     <none>
    Command:
      sleep
      4800
    State:          Running
      Started:      Tue, 09 Jun 2026 10:22:11 +0000
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-bvqf5 (ro)
Conditions:
  Type                        Status
  PodReadyToStartContainers   True 
  Initialized                 True 
  Ready                       True 
  ContainersReady             True 
  PodScheduled                True 
Volumes:
  kube-api-access-bvqf5:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    Optional:                false
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  29s   default-scheduler  Successfully assigned default/ubuntu-sleeper to controlplane
  Normal  Pulling    28s   kubelet            spec.containers{ubuntu}: Pulling image "ubuntu"
  Normal  Pulled     26s   kubelet            spec.containers{ubuntu}: Successfully pulled image "ubuntu" in 2.748s (2.748s including waiting). Image size: 41567720 bytes.
  Normal  Created    26s   kubelet            spec.containers{ubuntu}: Container created
  Normal  Started    25s   kubelet            spec.containers{ubuntu}: Container started

controlplane ~ ➜  #3

controlplane ~ ➜  ls
sample.yaml            ubuntu-sleeper-2.yaml  ubuntu-sleeper-3.yaml  webapp-color           webapp-color-2         webapp-color-3

controlplane ~ ➜  vi ubuntu-sleeper-2.yaml 

controlplane ~ ➜  k create -f ubuntu-sleeper-2.yaml
pod/ubuntu-sleeper-2 created

controlplane ~ ➜  #4

controlplane ~ ➜  k create -f ubuntu-sleeper-3.yaml
Error from server (BadRequest): error when creating "ubuntu-sleeper-3.yaml": Pod in version "v1" cannot be handled as a Pod: json: cannot unmarshal number into Go struct field Container.spec.containers.command of type string

controlplane ~ ✖ vi ubuntu-sleeper-3.yaml 

controlplane ~ ➜  k create -f ubuntu-sleeper-3.yaml
pod/ubuntu-sleeper-3 created

controlplane ~ ➜  #5

controlplane ~ ➜  vi ubuntu-sleeper-3.yaml 

controlplane ~ ➜  k apply -f ubuntu-sleeper-3.yaml
Warning: resource pods/ubuntu-sleeper-3 is missing the kubectl.kubernetes.io/last-applied-configuration annotation which is required by kubectl apply. kubectl apply should only be used on resources created declaratively by either kubectl create --save-config or kubectl apply. The missing annotation will be patched automatically.
The Pod "ubuntu-sleeper-3" is invalid: spec: Forbidden: pod updates may not change fields other than `spec.containers[*].image`,`spec.initContainers[*].image`,`spec.activeDeadlineSeconds`,`spec.tolerations` (only additions to existing tolerations),`spec.terminationGracePeriodSeconds` (allow it to be set to 1 if it was previously negative)
@@ -95,7 +95,7 @@
    "Image": "ubuntu",
    "Command": [
     "sleep",
-    "1200"
+    "2000"
    ],
    "Args": null,
    "WorkingDir": "",


controlplane ~ ✖ k edit pod ubuntu-sleeper-3 
error: pods "ubuntu-sleeper-3" is invalid
A copy of your changes has been stored to "/tmp/kubectl-edit-3318710568.yaml"
error: Edit cancelled, no valid changes were saved.

controlplane ~ ✖ k replace --force -f /tmp/kubectl-edit-3318710568.yaml
pod "ubuntu-sleeper-3" deleted from default namespace
pod/ubuntu-sleeper-3 replaced

controlplane ~ ➜  #6

controlplane ~ ➜  cat /r
root/ run/  

controlplane ~ ➜  cat /root/webapp-color
cat: read error: Is a directory

controlplane ~ ✖ cat /root/webapp-color/Dockerfile
FROM python:3.6-alpine

RUN pip install flask

COPY . /opt/

EXPOSE 8080

WORKDIR /opt

ENTRYPOINT ["python", "app.py"]

controlplane ~ ➜  #7

controlplane ~ ➜  cat /root/webapp-color/Dockerfile2
FROM python:3.6-alpine

RUN pip install flask

COPY . /opt/

EXPOSE 8080

WORKDIR /opt

ENTRYPOINT ["python", "app.py"]

CMD ["--color", "red"]

controlplane ~ ➜  #8

controlplane ~ ➜  

controlplane ~ ➜  cat webapp-color-pod.yaml
cat: can't open 'webapp-color-pod.yaml': No such file or directory

controlplane ~ ✖ ls
sample.yaml            ubuntu-sleeper-2.yaml  ubuntu-sleeper-3.yaml  webapp-color           webapp-color-2         webapp-color-3

controlplane ~ ➜  ls webapp-color-2
Dockerfile             webapp-color-pod.yaml

controlplane ~ ➜  cat webapp-color-2/webapp-color-pod.yaml 
apiVersion: v1 
kind: Pod 
metadata:
  name: webapp-green
  labels:
      name: webapp-green 
spec:
  containers:
  - name: simple-webapp
    image: kodekloud/webapp-color
    command: ["--color","green"]

controlplane ~ ➜  

controlplane ~ ➜  cat webapp-color-2/Dockerfile 
FROM python:3.6-alpine

RUN pip install flask

COPY . /opt/

EXPOSE 8080

WORKDIR /opt

ENTRYPOINT ["python", "app.py"]

CMD ["--color", "red"]

controlplane ~ ➜  #9

controlplane ~ ➜  cat webapp-color-3/webapp-color-pod-2.yaml 
apiVersion: v1 
kind: Pod 
metadata:
  name: webapp-green
  labels:
      name: webapp-green 
spec:
  containers:
  - name: simple-webapp
    image: kodekloud/webapp-color
    command: ["python", "app.py"]
    args: ["--color", "pink"]

controlplane ~ ➜  cat webapp-color-3/Dockerfile 
FROM python:3.6-alpine

RUN pip install flask

COPY . /opt/

EXPOSE 8080

WORKDIR /opt

ENTRYPOINT ["python", "app.py"]

CMD ["--color", "red"]

controlplane ~ ➜  #10

controlplane ~ ➜  ls
sample.yaml            ubuntu-sleeper-2.yaml  ubuntu-sleeper-3.yaml  webapp-color           webapp-color-2         webapp-color-3

controlplane ~ ➜  cd webapp-color-3

controlplane ~/webapp-color-3 ➜  ls
Dockerfile               webapp-color-pod-2.yaml

controlplane ~/webapp-color-3 ➜  vi webapp-color-pod-2.yaml 

controlplane ~/webapp-color-3 ➜  k create -f webapp-color-pod-2.yaml 
pod/webapp-green created```
# History
```cmd
# Rolling Updates and Rollbacks
controlplane ~ ➜  history
    1  #1
    2  k get pod
    3  k get svc
    4  #1
    5  ls
    6  bash /root/curl-test.sh
    7  #2,3
    8  #4
    9  k get deploy
   10  k describe deploy frontend
   11  #5
   12  #6
   13  #7
   14  #8
   15  k edit deploy frontend --image=kodekloud/webapp-color:v2
   16  k edit deploy frontend --help
   17  k edit deploy frontend
   18  k describe deploy frontend 
   19  #9
   20  bash /root/curl-test.sh
   21  #10
   22  #11
   23  k edit deploy frontend
   24  #12
   25  k edit deploy frontend
   26  #13
   27  bash /root/curl-test.sh
   28  history
   
# Commands and Arguments
controlplane ~/webapp-color-3 ➜  history
    1  #1
    2  k get pod
    3  #2
    4  k describe pod ubuntu-sleeper 
    5  #3
    6  ls
    7  vi ubuntu-sleeper-2.yaml 
    8  k create -f ubuntu-sleeper-2.yaml
    9  #4
   10  k create -f ubuntu-sleeper-3.yaml
   11  vi ubuntu-sleeper-3.yaml 
   12  k create -f ubuntu-sleeper-3.yaml
   13  #5
   14  vi ubuntu-sleeper-3.yaml 
   15  k apply -f ubuntu-sleeper-3.yaml
   16  k edit pod ubuntu-sleeper-3 
   17  k replace --force -f /tmp/kubectl-edit-3318710568.yaml
   18  #6
   19  cat /root/webapp-color
   20  cat /root/webapp-color/Dockerfile
   21  #7
   22  cat /root/webapp-color/Dockerfile2
   23  #8
   24  cat webapp-color-pod.yaml
   25  ls
   26  ls webapp-color-2
   27  cat webapp-color-2/webapp-color-pod.yaml 
   28  cat webapp-color-2/Dockerfile 
   29  #9
   30  cat webapp-color-3/webapp-color-pod-2.yaml 
   31  cat webapp-color-3/Dockerfile 
   32  #10
   33  ls
   34  cd webapp-color-3
   35  ls
   36  vi webapp-color-pod-2.yaml 
   37  k create -f webapp-color-pod-2.yaml 
   38  history
```

# Configmap
# Lab 8
# COnfigmap
```cmd
              
    __ ______  ____  ________ __ __    ____  __  ______ 
   / //_/ __ \/ __ \/ ____/ //_// /   / __ \/ / / / __ \
  / ,< / / / / / / / __/ / ,<  / /   / / / / / / / / / /
 / /| / /_/ / /_/ / /___/ /| |/ /___/ /_/ / /_/ / /_/ / 
/_/ |_\____/_____/_____/_/ |_/_____/\____/\____/_____/  
                                                        
                 All rights reserved                                                                                                                                  

controlplane ~ ➜  #1

controlplane ~ ➜  k get po
NAME           READY   STATUS    RESTARTS   AGE
webapp-color   1/1     Running   0          3m57s

controlplane ~ ➜  k get po -n default
NAME           READY   STATUS    RESTARTS   AGE
webapp-color   1/1     Running   0          4m1s

controlplane ~ ➜  #2

controlplane ~ ➜  k describe po webapp-color 
Name:             webapp-color
Namespace:        default
Priority:         0
Service Account:  default
Node:             controlplane/10.244.135.209
Start Time:       Wed, 03 Jun 2026 11:49:45 +0000
Labels:           name=webapp-color
Annotations:      <none>
Status:           Running
IP:               10.22.0.9
IPs:
  IP:  10.22.0.9
Containers:
  webapp-color:
    Container ID:   containerd://02f63e0972aaf99428619840668f9268b09ba5631331723b32c5039b86d4128e
    Image:          kodekloud/webapp-color
    Image ID:       docker.io/kodekloud/webapp-color@sha256:99c3821ea49b89c7a22d3eebab5c2e1ec651452e7675af243485034a72eb1423
    Port:           <none>
    Host Port:      <none>
    State:          Running
      Started:      Wed, 03 Jun 2026 11:49:56 +0000
    Ready:          True
    Restart Count:  0
    Environment:
      APP_COLOR:  pink
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-q25c5 (ro)
Conditions:
  Type                        Status
  PodReadyToStartContainers   True 
  Initialized                 True 
  Ready                       True 
  ContainersReady             True 
  PodScheduled                True 
Volumes:
  kube-api-access-q25c5:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    Optional:                false
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age    From               Message
  ----    ------     ----   ----               -------
  Normal  Scheduled  4m15s  default-scheduler  Successfully assigned default/webapp-color to controlplane
  Normal  Pulling    4m15s  kubelet            spec.containers{webapp-color}: Pulling image "kodekloud/webapp-color"
  Normal  Pulled     4m5s   kubelet            spec.containers{webapp-color}: Successfully pulled image "kodekloud/webapp-color" in 10.027s (10.027s including waiting). Image size: 31777918 bytes.
  Normal  Created    4m5s   kubelet            spec.containers{webapp-color}: Container created
  Normal  Started    4m5s   kubelet            spec.containers{webapp-color}: Container started

controlplane ~ ➜  k describe po webapp-color | grep -i env
    Environment:

controlplane ~ ➜  k describe po webapp-color | grep -i env -N5
grep: unrecognized option: N
BusyBox v1.35.0 (2022-08-01 15:14:44 UTC) multi-call binary.

Usage: grep [-HhnlLoqvsrRiwFE] [-m N] [-A|B|C N] { PATTERN | -e PATTERN... | -f FILE... } [FILE]...

Search for PATTERN in FILEs (or stdin)

        -H      Add 'filename:' prefix
        -h      Do not add 'filename:' prefix
        -n      Add 'line_no:' prefix
        -l      Show only names of files that match
        -L      Show only names of files that don't match
        -c      Show only count of matching lines
        -o      Show only the matching part of line
        -q      Quiet. Return 0 if PATTERN is found, 1 otherwise
        -v      Select non-matching lines
        -s      Suppress open and read errors
        -r      Recurse
        -R      Recurse and dereference symlinks
        -i      Ignore case
        -w      Match whole words only
        -x      Match whole lines only
        -F      PATTERN is a literal (not regexp)
        -E      PATTERN is an extended regexp
        -m N    Match up to N times per file
        -A N    Print N lines of trailing context
        -B N    Print N lines of leading context
        -C N    Same as '-A N -B N'
        -e PTRN Pattern to match
        -f FILE Read pattern from file

controlplane ~ ✖ k describe po webapp-color | grep -i env -C5
    Host Port:      <none>
    State:          Running
      Started:      Wed, 03 Jun 2026 11:49:56 +0000
    Ready:          True
    Restart Count:  0
    Environment:
      APP_COLOR:  pink
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-q25c5 (ro)
Conditions:
  Type                        Status

controlplane ~ ➜  #3

controlplane ~ ➜  #4

controlplane ~ ➜  #5

controlplane ~ ➜  k edit po webapp-color 
Error detected while processing /root/.vimrc:
line    2:
E117: Unknown function: pathogen#infect
line    4:
E185: Cannot find color scheme 'dracula'
Press ENTER or type command to continue
error: pods "webapp-color" is invalid
Error detected while processing /root/.vimrc:
line    2:
E117: Unknown function: pathogen#infect
line    4:
E185: Cannot find color scheme 'dracula'
Press ENTER or type command to continue
A copy of your changes has been stored to "/tmp/kubectl-edit-1952791348.yaml"
error: Edit cancelled, no valid changes were saved.

controlplane ~ ✖ k replace --force -f /tmp/kubectl-edit-1952791348.yaml
pod "webapp-color" deleted from default namespace
pod/webapp-color replaced

controlplane ~ ➜  #6

controlplane ~ ➜  #7

controlplane ~ ➜  k get configmaps -n default
NAME               DATA   AGE
db-config          3      18s
kube-root-ca.crt   1      15m

controlplane ~ ➜  k get configmaps -n default -o wide
NAME               DATA   AGE
db-config          3      26s
kube-root-ca.crt   1      15m

controlplane ~ ➜  #8

controlplane ~ ➜  k get configmaps db-config 
NAME        DATA   AGE
db-config   3      49s

controlplane ~ ➜  k describe configmaps db-config 
Name:         db-config
Namespace:    default
Labels:       <none>
Annotations:  <none>

Data
====
DB_HOST:
----
SQL01.example.com

DB_NAME:
----
SQL01

DB_PORT:
----
3306


BinaryData
====

Events:  <none>

controlplane ~ ➜  k api-resources | grep -i configmap -C5
NAME                                SHORTNAMES   APIVERSION                          NAMESPACED   KIND
bindings                                         v1                                  true         Binding
componentstatuses                   cs           v1                                  false        ComponentStatus
configmaps                          cm           v1                                  true         ConfigMap
endpoints                           ep           v1                                  true         Endpoints
events                              ev           v1                                  true         Event
limitranges                         limits       v1                                  true         LimitRange
namespaces                          ns           v1                                  false        Namespace
nodes                               no           v1                                  false        Node

controlplane ~ ➜  #9

controlplane ~ ➜  k create configmap webapp-config-map --from-literal=APP_COLOR=darkblue --from-literal=APP_OTHER=disregard
configmap/webapp-config-map created

controlplane ~ ➜  #10

controlplane ~ ➜  k edit pod webapp-color 
Error detected while processing /root/.vimrc:
line    2:
E117: Unknown function: pathogen#infect
line    4:
E185: Cannot find color scheme 'dracula'
Press ENTER or type command to continue
error: pods "webapp-color" is invalid
Error detected while processing /root/.vimrc:
line    2:
E117: Unknown function: pathogen#infect
line    4:
E185: Cannot find color scheme 'dracula'
Press ENTER or type command to continue
error: pods "webapp-color" is invalid
Error detected while processing /root/.vimrc:
line    2:
E117: Unknown function: pathogen#infect
line    4:
E185: Cannot find color scheme 'dracula'
Press ENTER or type command to continue
A copy of your changes has been stored to "/tmp/kubectl-edit-76221615.yaml"
error: Edit cancelled, no valid changes were saved.

controlplane ~ ✖ k delete po webapp-color 
pod "webapp-color" deleted from default namespace

controlplane ~ ➜  k create -f /tmp/kubectl-edit-76221615.yaml
pod/webapp-color created

controlplane ~ ➜  #11

controlplane ~ ➜  history
    1  #1
    2  k get po
    3  k get po -n default
    4  #2
    5  k describe po webapp-color 
    6  k describe po webapp-color | grep -i env
    7  k describe po webapp-color | grep -i env -N5
    8  k describe po webapp-color | grep -i env -C5
    9  #3
   10  #4
   11  #5
   12  k edit po webapp-color 
   13  k replace --force -f /tmp/kubectl-edit-1952791348.yaml
   14  #6
   15  #7
   16  k get configmaps -n default
   17  k get configmaps -n default -o wide
   18  #8
   19  k get configmaps db-config 
   20  k describe configmaps db-config 
   21  k api-resources | grep -i configmap -C5
   22  #9
   23  k create configmap webapp-config-map --from-literal=APP_COLOR=darkblue --from-literal=APP_OTHER=disregard
   24  #10
   25  k edit pod webapp-color 
   26  k delete po webapp-color 
   27  k create -f /tmp/kubectl-edit-76221615.yaml
   28  #11
   29  history

```
# Secrets
```cmd
             Welcome to the KodeKloud Hands-On lab                                                                                                                                                              
    __ ______  ____  ________ __ __    ____  __  ______ 
   / //_/ __ \/ __ \/ ____/ //_// /   / __ \/ / / / __ \
  / ,< / / / / / / / __/ / ,<  / /   / / / / / / / / / /
 / /| / /_/ / /_/ / /___/ /| |/ /___/ /_/ / /_/ / /_/ / 
/_/ |_\____/_____/_____/_/ |_/_____/\____/\____/_____/  
                                                        
                     All rights reserved                                                                                                                                                                        

controlplane ~ ➜  history
    1  history

controlplane ~ ➜  #1 

controlplane ~ ➜  k get secrets
NAME              TYPE                                  DATA   AGE
dashboard-token   kubernetes.io/service-account-token   3      5m1s

controlplane ~ ➜  #2

controlplane ~ ➜  k describe secrets dashboard-token
Name:         dashboard-token
Namespace:    default
Labels:       <none>
Annotations:  kubernetes.io/service-account.name: dashboard-sa
              kubernetes.io/service-account.uid: 5cb87d95-1bdf-4eae-8485-e8ebf06e6e8c

Type:  kubernetes.io/service-account-token

Data
====
ca.crt:     566 bytes
namespace:  7 bytes
token:      eyJhbGciOiJSUzI1NiIsImtpZCI6ImpIcktXNC1OMmIwOVBkalR4TlRYcnBLUWFOcDhmWnV1azJIaVJKQm95Z3cifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJkZWZhdWx0Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZWNyZXQubmFtZSI6ImRhc2hib2FyZC10b2tlbiIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50Lm5hbWUiOiJkYXNoYm9hcmQtc2EiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC51aWQiOiI1Y2I4N2Q5NS0xYmRmLTRlYWUtODQ4NS1lOGViZjA2ZTZlOGMiLCJzdWIiOiJzeXN0ZW06c2VydmljZWFjY291bnQ6ZGVmYXVsdDpkYXNoYm9hcmQtc2EifQ.sBDdp4yGB2CoP2lnBR-VyMhdwCrkOtQwgg-dhhxJ9wiPMZyQwKch8hmTHSbwI-qBdoFooOuVNQP4jboj5qfLN9cw5KMw6hMHNHYQcm5Lw__iYLoGRwxfmLun9VXtPDnscuTM0msHJCMyr_kEk50_4ruWPMQU-p1MPFD1Wa6Qxfve-aBMkjiCHzl_5Yu5j0Wkl2YbgJWYuGqeVgoSgXgnOvUNjlt6oSOoMVXz1s4PsJVtmDqxwalky-aRK-ORyn-ikToQAE4Df7IzbU5bjd7GyDD7KlyyFg2BK46xiYxH972qiqX8vW6nIwJXag5OAEBBbqa-6LwQaegNfxHdE0KrnA

controlplane ~ ➜  #3

controlplane ~ ➜  #4

controlplane ~ ➜  #5

controlplane ~ ➜  k get deployments.apps 
\No resources found in default namespace.

controlplane ~ ➜  k get deployments.apps
No resources found in default namespace.

controlplane ~ ➜  k get deploy
No resources found in default namespace.

controlplane ~ ➜  k get pods
NAME         READY   STATUS    RESTARTS   AGE
mysql        1/1     Running   0          54s
webapp-pod   1/1     Running   0          54s

controlplane ~ ➜  k get svc
NAME             TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
kubernetes       ClusterIP   10.43.0.1      <none>        443/TCP          14m
sql01            ClusterIP   10.43.78.218   <none>        3306/TCP         62s
webapp-service   NodePort    10.43.92.30    <none>        8080:30080/TCP   62s

controlplane ~ ➜  k get secret
NAME              TYPE                                  DATA   AGE
dashboard-token   kubernetes.io/service-account-token   3      6m47s

controlplane ~ ➜  #6

controlplane ~ ➜  k create secret --help
Create a secret with specified type.

 A docker-registry type secret is for accessing a container registry.

 A generic type secret indicate an Opaque secret type.

 A tls type secret holds TLS certificate and its associated key.

Available Commands:
  docker-registry   Create a secret for use with a Docker registry
  generic           Create a secret from a local file, directory, or literal value
  tls               Create a TLS secret

Usage:
  kubectl create secret (docker-registry | generic | tls) [options]

Use "kubectl create secret <command> --help" for more information about a given command.
Use "kubectl options" for a list of global command-line options (applies to all commands).

controlplane ~ ➜  kubectl create secret <command> --help
-bash: command: No such file or directory

controlplane ~ ✖ kubectl create secret generic --help
Create a secret based on a file, directory, or specified literal value.

 A single secret may package one or more key/value pairs.

 When creating a secret based on a file, the key will default to the basename of the file, and the value will default to
the file content. If the basename is an invalid key or you wish to chose your own, you may specify an alternate key.

 When creating a secret based on a directory, each file whose basename is a valid key in the directory will be packaged
into the secret. Any directory entries except regular files are ignored (e.g. subdirectories, symlinks, devices, pipes,
etc).

Examples:
  # Create a new secret named my-secret with keys for each file in folder bar
  kubectl create secret generic my-secret --from-file=path/to/bar
  
  # Create a new secret named my-secret with specified keys instead of names on disk
  kubectl create secret generic my-secret --from-file=ssh-privatekey=path/to/id_rsa
--from-file=ssh-publickey=path/to/id_rsa.pub
  
  # Create a new secret named my-secret with key1=supersecret and key2=topsecret
  kubectl create secret generic my-secret --from-literal=key1=supersecret --from-literal=key2=topsecret
  
  # Create a new secret named my-secret using a combination of a file and a literal
  kubectl create secret generic my-secret --from-file=ssh-privatekey=path/to/id_rsa --from-literal=passphrase=topsecret
  
  # Create a new secret named my-secret from env files
  kubectl create secret generic my-secret --from-env-file=path/to/foo.env --from-env-file=path/to/bar.env

Options:
    --allow-missing-template-keys=true:
        If true, ignore any errors in templates when a field or map key is missing in the template. Only applies to
        golang and jsonpath output formats.

    --append-hash=false:
        Append a hash of the secret to its name.

    --dry-run='none':
        Must be "none", "server", or "client". If client strategy, only print the object that would be sent, without
        sending it. If server strategy, submit server-side request without persisting the resource.

    --field-manager='kubectl-create':
        Name of the manager used to track field ownership.

    --from-env-file=[]:
        Specify the path to a file to read lines of key=val pairs to create a secret.

    --from-file=[]:
        Key files can be specified using their file path, in which case a default name will be given to them, or
        optionally with a name and file path, in which case the given name will be used.  Specifying a directory will
        iterate each named file in the directory that is a valid secret key.

    --from-literal=[]:
        Specify a key and literal value to insert in secret (i.e. mykey=somevalue)

    -o, --output='':
        Output format. One of: (json, yaml, kyaml, name, go-template, go-template-file, template, templatefile,
        jsonpath, jsonpath-as-json, jsonpath-file).

    --save-config=false:
        If true, the configuration of current object will be saved in its annotation. Otherwise, the annotation will
        be unchanged. This flag is useful when you want to perform kubectl apply on this object in the future.

    --show-managed-fields=false:
        If true, keep the managedFields when printing objects in JSON or YAML format.

    --template='':
        Template string or path to template file to use when -o=go-template, -o=go-template-file. The template format
        is golang templates [http://golang.org/pkg/text/template/#pkg-overview].

    --type='':
        The type of secret to create

    --validate='strict':
        Must be one of: strict (or true), warn, ignore (or false). "true" or "strict" will use a schema to validate
        the input and fail the request if invalid. It will perform server side validation if ServerSideFieldValidation
        is enabled on the api-server, but will fall back to less reliable client-side validation if not. "warn" will
        warn about unknown or duplicate fields without blocking the request if server-side field validation is enabled
        on the API server, and behave as "ignore" otherwise. "false" or "ignore" will not perform any schema
        validation, silently dropping any unknown or duplicate fields.

Usage:
  kubectl create secret generic NAME [--type=string] [--from-file=[key=]source] [--from-literal=key1=value1]
[--dry-run=server|client|none] [options]

Use "kubectl options" for a list of global command-line options (applies to all commands).

controlplane ~ ➜  k create secret generic db-scret --from-literal=DB_Host=sql01 --from-literal=DB_User=root --from-literal=DB_Password=password123
secret/db-scret created

controlplane ~ ➜  k get secrets db-scret 
NAME       TYPE     DATA   AGE
db-scret   Opaque   3      8s

controlplane ~ ➜  k create secret generic db-secret --from-literal=DB_Host=sql01 --from-literal=DB_User=root --from-literal=DB_Password=password123
secret/db-secret created

controlplane ~ ➜  k describe secrets db-secret 
Name:         db-secret
Namespace:    default
Labels:       <none>
Annotations:  <none>

Type:  Opaque

Data
====
DB_Host:      5 bytes
DB_Password:  11 bytes
DB_User:      4 bytes

controlplane ~ ➜  k get secrets db-secret -oyaml
apiVersion: v1
data:
  DB_Host: c3FsMDE=
  DB_Password: cGFzc3dvcmQxMjM=
  DB_User: cm9vdA==
kind: Secret
metadata:
  creationTimestamp: "2026-06-10T08:40:40Z"
  name: db-secret
  namespace: default
  resourceVersion: "1121"
  uid: 678e1728-b94f-496c-999f-8defc487d77c
type: Opaque

controlplane ~ ➜  #7

controlplane ~ ➜  k edit pod webapp-pod 
error: pods "webapp-pod" is invalid
A copy of your changes has been stored to "/tmp/kubectl-edit-2077305154.yaml"
error: Edit cancelled, no valid changes were saved.

controlplane ~ ✖ k replace --force -f /tmp/kubectl-edit-2077305154.yaml
pod "webapp-pod" deleted from default namespace
pod/webapp-pod replaced

controlplane ~ ➜  k describe pod webapp-pod | grep -i "envFrom" -C5

controlplane ~ ✖ k get pod webapp-pod -oyaml | grep -i "envFrom" -C5
  namespace: default
  resourceVersion: "1259"
  uid: ac92d83f-1c58-4d8d-a591-9563334de753
spec:
  containers:
  - envFrom:
    - secretRef:
        name: db-secret
    image: kodekloud/simple-webapp-mysql
    imagePullPolicy: Always
    name: webapp

controlplane ~ ➜  #8

controlplane ~ ➜  history
    1  history
    2  #1 
    3  k get secrets
    4  #2
    5  k describe secrets dashboard-token
    6  #3
    7  #4
    8  #5
    9  k get deployments.apps 
   10  k get deployments.apps
   11  k get deploy
   12  k get pods
   13  k get svc
   14  k get secret
   15  #6
   16  k create secret --help
   17  kubectl create secret <command> --help
   18  kubectl create secret generic --help
   19  k create secret generic db-scret --from-literal=DB_Host=sql01 --from-literal=DB_User=root --from-literal=DB_Password=password123
   20  k get secrets db-scret 
   21  k create secret generic db-secret --from-literal=DB_Host=sql01 --from-literal=DB_User=root --from-literal=DB_Password=password123
   22  k describe secrets db-secret 
   23  k get secrets db-secret -oyaml
   24  #7
   25  k edit pod webapp-pod 
   26  k replace --force -f /tmp/kubectl-edit-2077305154.yaml
   27  k describe pod webapp-pod | grep -i "envFrom" -C5
   28  k get pod webapp-pod -oyaml | grep -i "envFrom" -C5
   29  #8
   30  history
```

# Multi-containers Pod
```cmd
controlplane ~ ➜  history
1  #1
2  k get pod red -o wide
3  #2
4  k describe pod blue
5  #3
6  ls
7  k get pod blue -oyaml > q3.yaml
8  vi q3.yaml
9  k create -f q3.yaml
10  k run yellow --image=busybox --dry-run=client -oyaml > q31.yaml
11  vi q31.yaml
12  #4
13  k get pod -n elastic-stack
14  #5
15  kubectl -n elastic-stack logs kibana
16  #6
17  k get -n elastic-stack pod app
18  #7
19  ls
20  k exec --help
21  k exec app -- cat /log/app.log
22  k exec --help
23  kubectl -n elastic-stack exec -it app -- cat /log/app.log
24  kubectl -n elastic-stack exec -it app -- sh -c "cat /log/app.log | grep -i 'warning\|error'"
25  kubectl -n elastic-stack exec app -- grep -i 'login' /log/app.log | grep -i 'fail'
26  kubectl -n elastic-stack exec -it app -- grep -i 'failed' /log/app.log
27  #8
28  clr
29  clear
30  k edit pod app
31  k replace --force -f /tmp/kubectl-edit-2006853867.yaml
32  k get pod app -oyaml
33  k edit pod app
34  k replace --force -f /tmp/kubectl-edit-4012914935.yaml
35  k edit pod app
36  k get -n elastic-stack pod
37  k get -n default pod
38  k replace --force -f /tmp/kubectl-edit-4012914935.yaml -n elastic-stack
39  k delete pod -n elastic-stack app
40  k create -n elastic-stack -f /tmp/kubectl-edit-4012914935.yaml
41  k edit app
42  k edit pod app
43  k create -n elastic-stack -f /tmp/kubectl-edit-6847627.yaml
44  #9
45  history

```

# Init Containers
```cmd
controlplane ~ ➜  history
    1  #1
    2  k get pod
    3  k describe pod blue | grep -i "initContainer" -C3
    4  k describe pod green | grep -i "initContainer" -C3
    5  k describe pod red | grep -i "initContainer" -C3
    6  k describe pod blue
    7  #2
    8  #3
    9  #4
   10  k describe pod purple
   11  #6
   12  #7
   13  #8
   14  k get pod red -oyaml > q8.yaml
   15  vi q8.yaml 
   16  k apply -f q8.yaml 
   17  k delete pod red
   18  k apply -f q8.yaml 
   19  k get pod
   20  k describe pod red
   21  vi q8.yaml 
   22  k replace -f q8.yaml --force
   23  k get pod
   24  k describe pod red
   25  #9
   26  k describe pod red
   27  k get pod
   28  k describe pod orange 
   29  k logs orange 
   30  k logs orange -c init-myservice
   31  k edit orange
   32  k edit pod orange
   33  k replace --force- f /tmp/kubectl-edit-2266287673.yaml
   34  k replace --force -f /tmp/kubectl-edit-2266287673.yaml
   35  history
```

# Manual Scaling
```cmd
             Welcome to the KodeKloud Hands-On lab                                                                                                                                                       
    __ ______  ____  ________ __ __    ____  __  ______ 
   / //_/ __ \/ __ \/ ____/ //_// /   / __ \/ / / / __ \
  / ,< / / / / / / / __/ / ,<  / /   / / / / / / / / / /
 / /| / /_/ / /_/ / /___/ /| |/ /___/ /_/ / /_/ / /_/ / 
/_/ |_\____/_____/_____/_/ |_/_____/\____/\____/_____/  
                                                        
                     All rights reserved                                                                                                                                                                 

controlplane ~ ➜  #1

controlplane ~ ➜  #2

controlplane ~ ➜  k create -f  /root/deployment.yml
deployment.apps/flask-web-app created

service/flask-web-app-service created

controlplane ~ ➜  

controlplane ~ ➜  k get deploy
NAME            READY   UP-TO-DATE   AVAILABLE   AGE
flask-web-app   0/2     2            0           5s

controlplane ~ ➜  k get pod
NAME                            READY   STATUS    RESTARTS   AGE
flask-web-app-66ffff88d-l429h   1/1     Running   0          11s
flask-web-app-66ffff88d-p2fqg   1/1     Running   0          11s

controlplane ~ ➜  k get deploy
NAME            READY   UP-TO-DATE   AVAILABLE   AGE
flask-web-app   2/2     2            2           13s

controlplane ~ ➜  #3

controlplane ~ ➜  #4

controlplane ~ ➜  #5

controlplane ~ ➜  k scale deploy flask-web-app --help
Set a new size for a deployment, replica set, replication controller, or stateful set.

 Scale also allows users to specify one or more preconditions for the scale action.

 If --current-replicas or --resource-version is specified, it is validated before the scale is attempted, and it is
guaranteed that the precondition holds true when the scale is sent to the server.

Examples:
  # Scale a replica set named 'foo' to 3
  kubectl scale --replicas=3 rs/foo
  
  # Scale a resource identified by type and name specified in "foo.yaml" to 3
  kubectl scale --replicas=3 -f foo.yaml
  
  # If the deployment named mysql's current size is 2, scale mysql to 3
  kubectl scale --current-replicas=2 --replicas=3 deployment/mysql
  
  # Scale multiple replication controllers
  kubectl scale --replicas=5 rc/example1 rc/example2 rc/example3
  
  # Scale stateful set named 'web' to 3
  kubectl scale --replicas=3 statefulset/web

Options:
    --all=false:
        Select all resources in the namespace of the specified resource types

    --allow-missing-template-keys=true:
        If true, ignore any errors in templates when a field or map key is missing in the template. Only applies to
        golang and jsonpath output formats.

    --current-replicas=-1:
        Precondition for current size. Requires that the current size of the resource match this value in order to
        scale. -1 (default) for no condition.

    --dry-run='none':
        Must be "none", "server", or "client". If client strategy, only print the object that would be sent, without
        sending it. If server strategy, submit server-side request without persisting the resource.

    -f, --filename=[]:
        Filename, directory, or URL to files identifying the resource to set a new size

    -k, --kustomize='':
        Process the kustomization directory. This flag can't be used together with -f or -R.

    -o, --output='':
        Output format. One of: (json, yaml, kyaml, name, go-template, go-template-file, template, templatefile,
        jsonpath, jsonpath-as-json, jsonpath-file).

    -R, --recursive=false:
        Process the directory used in -f, --filename recursively. Useful when you want to manage related manifests
        organized within the same directory.

    --replicas=0:
        The new desired number of replicas. Required.

    --resource-version='':
        Precondition for resource version. Requires that the current resource version match this value in order to
        scale.

    -l, --selector='':
        Selector (label query) to filter on, supports '=', '==', '!=', 'in', 'notin'.(e.g. -l
        key1=value1,key2=value2,key3 in (value3)). Matching objects must satisfy all of the specified label
        constraints.

    --show-managed-fields=false:
        If true, keep the managedFields when printing objects in JSON or YAML format.

    --template='':
        Template string or path to template file to use when -o=go-template, -o=go-template-file. The template format
        is golang templates [http://golang.org/pkg/text/template/#pkg-overview].

    --timeout=0s:
        The length of time to wait before giving up on a scale operation, zero means don't wait. Any other values
        should contain a corresponding time unit (e.g. 1s, 2m, 3h).

Usage:
  kubectl scale [--resource-version=version] [--current-replicas=count] --replicas=COUNT (-f FILENAME | TYPE NAME)
[options]

Use "kubectl options" for a list of global command-line options (applies to all commands).

controlplane ~ ➜  k scale deploy/flask-web-app --replicas=3
deployment.apps/flask-web-app scaled

controlplane ~ ➜  #6

controlplane ~ ➜  history
    1  #1
    2  #2
    3  k create -f  /root/deployment.yml
    4  k get deploy
    5  k get pod
    6  k get deploy
    7  #3
    8  #4
    9  #5
   10  k scale deploy flask-web-app --help
   11  k scale deploy/flask-web-app --replicas=3
   12  #6
   13  history
```

# HPA
```cmd
             Welcome to the KodeKloud Hands-On lab                                                                                                                                                       
    __ ______  ____  ________ __ __    ____  __  ______ 
   / //_/ __ \/ __ \/ ____/ //_// /   / __ \/ / / / __ \
  / ,< / / / / / / / __/ / ,<  / /   / / / / / / / / / /
 / /| / /_/ / /_/ / /___/ /| |/ /___/ /_/ / /_/ / /_/ / 
/_/ |_\____/_____/_____/_/ |_/_____/\____/\____/_____/  
                                                        
                     All rights reserved                                                                                                                                                                 

controlplane ~ ➜  #1

controlplane ~ ➜  #2

controlplane ~ ➜  k create -f /root/deployment.yml 
deployment.apps/nginx-deployment created

controlplane ~ ➜  k get deploy
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
nginx-deployment   0/7     7            0           5s

controlplane ~ ➜  k get deploy -w
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
nginx-deployment   7/7     7            7           12s
^C
controlplane ~ ✖ #3

controlplane ~ ✖ cat /root/autoscale.yml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  creationTimestamp: null
  name: nginx-deployment
spec:
  maxReplicas: 3
  metrics:
  - resource:
      name: cpu
      target:
        averageUtilization: 80
        type: Utilization
    type: Resource
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: nginx-deployment
status:
  currentMetrics: null
  desiredReplicas: 0
  currentReplicas: 0
controlplane ~ ➜  #4

controlplane ~ ➜  k create -f /root/autoscale.yml
horizontalpodautoscaler.autoscaling/nginx-deployment created

controlplane ~ ➜  kubectl autoscale deployment nginx-deployment --max=3 --cpu=80%
Error from server (AlreadyExists): horizontalpodautoscalers.autoscaling "nginx-deployment" already exists

controlplane ~ ✖ #5

controlplane ~ ✖ #6

controlplane ~ ✖ #7

controlplane ~ ✖ k get deploy
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
nginx-deployment   3/3     3            3           2m39s

controlplane ~ ➜  #8

controlplane ~ ➜  k get horizontalpodautoscalers nginx-deployment 
NAME               REFERENCE                     TARGETS              MINPODS   MAXPODS   REPLICAS   AGE
nginx-deployment   Deployment/nginx-deployment   cpu: <unknown>/80%   1         3         3          104s

controlplane ~ ➜  k get hpa
NAME               REFERENCE                     TARGETS              MINPODS   MAXPODS   REPLICAS   AGE
nginx-deployment   Deployment/nginx-deployment   cpu: <unknown>/80%   1         3         3          2m10s

controlplane ~ ➜  k describe hpa nginx-deployment 
Name:                                                  nginx-deployment
Namespace:                                             default
Labels:                                                <none>
Annotations:                                           <none>
CreationTimestamp:                                     Wed, 10 Jun 2026 11:59:54 +0000
Reference:                                             Deployment/nginx-deployment
Metrics:                                               ( current / target )
  resource cpu on pods  (as a percentage of request):  <unknown> / 80%
Min replicas:                                          1
Max replicas:                                          3
Deployment pods:                                       3 current / 3 desired
Conditions:
  Type           Status  Reason                   Message
  ----           ------  ------                   -------
  AbleToScale    True    SucceededGetScale        the HPA controller was able to get the target's current scale
  ScalingActive  False   FailedGetResourceMetric  the HPA was unable to compute the replica count: failed to get cpu utilization: missing request for cpu in container nginx of Pod nginx-deployment-77bc6bd484-dd9pq
Events:
  Type     Reason                        Age                 From                       Message
  ----     ------                        ----                ----                       -------
  Normal   SuccessfulRescale             2m16s               horizontal-pod-autoscaler  New size: 3; reason: Current number of replicas above Spec.MaxReplicas
  Warning  FailedGetResourceMetric       46s (x2 over 76s)   horizontal-pod-autoscaler  failed to get cpu utilization: missing request for cpu in container nginx of Pod nginx-deployment-77bc6bd484-vnvtf
  Warning  FailedComputeMetricsReplicas  46s (x2 over 76s)   horizontal-pod-autoscaler  invalid metrics (1 invalid out of 1), first error is: failed to get cpu resource metric value: failed to get cpu utilization: missing request for cpu in container nginx of Pod nginx-deployment-77bc6bd484-vnvtf
  Warning  FailedGetResourceMetric       16s (x5 over 2m1s)  horizontal-pod-autoscaler  failed to get cpu utilization: missing request for cpu in container nginx of Pod nginx-deployment-77bc6bd484-r7mr6
  Warning  FailedComputeMetricsReplicas  16s (x5 over 2m1s)  horizontal-pod-autoscaler  invalid metrics (1 invalid out of 1), first error is: failed to get cpu resource metric value: failed to get cpu utilization: missing request for cpu in container nginx of Pod nginx-deployment-77bc6bd484-r7mr6
  Warning  FailedGetResourceMetric       1s (x2 over 91s)    horizontal-pod-autoscaler  failed to get cpu utilization: missing request for cpu in container nginx of Pod nginx-deployment-77bc6bd484-dd9pq
  Warning  FailedComputeMetricsReplicas  1s (x2 over 91s)    horizontal-pod-autoscaler  invalid metrics (1 invalid out of 1), first error is: failed to get cpu resource metric value: failed to get cpu utilization: missing request for cpu in container nginx of Pod nginx-deployment-77bc6bd484-dd9pq

controlplane ~ ➜  k describe deploy nginx-deployment 
Name:                   nginx-deployment
Namespace:              default
CreationTimestamp:      Wed, 10 Jun 2026 11:58:20 +0000
Labels:                 app=nginx
Annotations:            deployment.kubernetes.io/revision: 1
Selector:               app=nginx
Replicas:               3 desired | 3 updated | 3 total | 3 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  app=nginx
  Containers:
   nginx:
    Image:         nginx:1.14.2
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
NewReplicaSet:   nginx-deployment-77bc6bd484 (3/3 replicas created)
Events:
  Type    Reason             Age    From                   Message
  ----    ------             ----   ----                   -------
  Normal  ScalingReplicaSet  5m50s  deployment-controller  Scaled up replica set nginx-deployment-77bc6bd484 from 0 to 7
  Normal  ScalingReplicaSet  4m1s   deployment-controller  Scaled down replica set nginx-deployment-77bc6bd484 from 7 to 3

controlplane ~ ➜  cat /root/deployment.yml 
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 7
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
        resources:
         requests:
           cpu: 100m
         limits:
           cpu: 200m

controlplane ~ ➜  k apply -f /root/deployment.yml 
Warning: resource deployments/nginx-deployment is missing the kubectl.kubernetes.io/last-applied-configuration annotation which is required by kubectl apply. kubectl apply should only be used on resources created declaratively by either kubectl create --save-config or kubectl apply. The missing annotation will be patched automatically.
deployment.apps/nginx-deployment configured

controlplane ~ ➜  k replace --force -f /root/deployment.yml 
deployment.apps "nginx-deployment" deleted from default namespace
deployment.apps/nginx-deployment replaced

controlplane ~ ➜  #11

controlplane ~ ➜  k describe hpa nginx-deployment 
Name:                                                  nginx-deployment
Namespace:                                             default
Labels:                                                <none>
Annotations:                                           <none>
CreationTimestamp:                                     Wed, 10 Jun 2026 11:59:54 +0000
Reference:                                             Deployment/nginx-deployment
Metrics:                                               ( current / target )
  resource cpu on pods  (as a percentage of request):  0% (0) / 80%
Min replicas:                                          1
Max replicas:                                          3
Deployment pods:                                       1 current / 1 desired
Conditions:
  Type            Status  Reason            Message
  ----            ------  ------            -------
  AbleToScale     True    ReadyForNewScale  recommended size matches current size
  ScalingActive   True    ValidMetricFound  the HPA was able to successfully calculate a replica count from cpu resource utilization (percentage of request)
  ScalingLimited  True    TooFewReplicas    the desired replica count is less than the minimum replica count
Events:
  Type     Reason                        Age                    From                       Message
  ----     ------                        ----                   ----                       -------
  Warning  FailedComputeMetricsReplicas  4m41s (x3 over 6m11s)  horizontal-pod-autoscaler  invalid metrics (1 invalid out of 1), first error is: failed to get cpu resource metric value: failed to get cpu utilization: missing request for cpu in container nginx of Pod nginx-deployment-77bc6bd484-vnvtf
  Warning  FailedGetResourceMetric       4m26s (x6 over 6m56s)  horizontal-pod-autoscaler  failed to get cpu utilization: missing request for cpu in container nginx of Pod nginx-deployment-77bc6bd484-r7mr6
  Warning  FailedComputeMetricsReplicas  4m26s (x6 over 6m56s)  horizontal-pod-autoscaler  invalid metrics (1 invalid out of 1), first error is: failed to get cpu resource metric value: failed to get cpu utilization: missing request for cpu in container nginx of Pod nginx-deployment-77bc6bd484-r7mr6
  Warning  FailedGetResourceMetric       4m11s (x3 over 6m26s)  horizontal-pod-autoscaler  failed to get cpu utilization: missing request for cpu in container nginx of Pod nginx-deployment-77bc6bd484-dd9pq
  Warning  FailedComputeMetricsReplicas  4m11s (x3 over 6m26s)  horizontal-pod-autoscaler  invalid metrics (1 invalid out of 1), first error is: failed to get cpu resource metric value: failed to get cpu utilization: missing request for cpu in container nginx of Pod nginx-deployment-77bc6bd484-dd9pq
  Warning  FailedGetResourceMetric       3m56s (x4 over 6m11s)  horizontal-pod-autoscaler  failed to get cpu utilization: missing request for cpu in container nginx of Pod nginx-deployment-77bc6bd484-vnvtf
  Normal   SuccessfulRescale             86s (x3 over 7m11s)    horizontal-pod-autoscaler  New size: 3; reason: Current number of replicas above Spec.MaxReplicas
  Warning  FailedGetResourceMetric       71s                    horizontal-pod-autoscaler  failed to get cpu utilization: did not receive metrics for targeted pods (pods might be unready)
  Normal   SuccessfulRescale             56s (x2 over 101s)     horizontal-pod-autoscaler  New size: 1; reason: All metrics below target

controlplane ~ ➜  k describe hpa nginx-deployment | grep -i "ScalingReplicaSet"

controlplane ~ ✖ k describe hpa nginx-deployment | grep -i "ScalingReplicaSet" -C3

controlplane ~ ✖ k get hpa -owide
NAME               REFERENCE                     TARGETS       MINPODS   MAXPODS   REPLICAS   AGE
nginx-deployment   Deployment/nginx-deployment   cpu: 0%/80%   1         3         1          9m20s

controlplane ~ ➜  k get hpa nginx-deployment -o wide
NAME               REFERENCE                     TARGETS       MINPODS   MAXPODS   REPLICAS   AGE
nginx-deployment   Deployment/nginx-deployment   cpu: 0%/80%   1         3         1          9m31s

controlplane ~ ➜  k get hpa -oyaml
apiVersion: v1
items:
- apiVersion: autoscaling/v2
  kind: HorizontalPodAutoscaler
  metadata:
    creationTimestamp: "2026-06-10T11:59:54Z"
    name: nginx-deployment
    namespace: default
    resourceVersion: "5757"
    uid: 11936f2c-bd17-48ae-a089-4163db1b1815
  spec:
    maxReplicas: 3
    metrics:
    - resource:
        name: cpu
        target:
          averageUtilization: 80
          type: Utilization
      type: Resource
    minReplicas: 1
    scaleTargetRef:
      apiVersion: apps/v1
      kind: Deployment
      name: nginx-deployment
  status:
    conditions:
    - lastTransitionTime: "2026-06-10T12:00:09Z"
      message: recommended size matches current size
      reason: ReadyForNewScale
      status: "True"
      type: AbleToScale
    - lastTransitionTime: "2026-06-10T12:06:24Z"
      message: the HPA was able to successfully calculate a replica count from cpu
        resource utilization (percentage of request)
      reason: ValidMetricFound
      status: "True"
      type: ScalingActive
    - lastTransitionTime: "2026-06-10T12:05:39Z"
      message: the desired replica count is less than the minimum replica count
      reason: TooFewReplicas
      status: "True"
      type: ScalingLimited
    currentMetrics:
    - resource:
        current:
          averageUtilization: 0
          averageValue: "0"
        name: cpu
      type: Resource
    currentReplicas: 1
    desiredReplicas: 1
    lastScaleTime: "2026-06-10T12:06:24Z"
kind: List
metadata:
  resourceVersion: ""

controlplane ~ ➜  k describe hpa nginx-deployment 
Name:                                                  nginx-deployment
Namespace:                                             default
Labels:                                                <none>
Annotations:                                           <none>
CreationTimestamp:                                     Wed, 10 Jun 2026 11:59:54 +0000
Reference:                                             Deployment/nginx-deployment
Metrics:                                               ( current / target )
  resource cpu on pods  (as a percentage of request):  0% (0) / 80%
Min replicas:                                          1
Max replicas:                                          3
Deployment pods:                                       1 current / 1 desired
Conditions:
  Type            Status  Reason            Message
  ----            ------  ------            -------
  AbleToScale     True    ReadyForNewScale  recommended size matches current size
  ScalingActive   True    ValidMetricFound  the HPA was able to successfully calculate a replica count from cpu resource utilization (percentage of request)
  ScalingLimited  True    TooFewReplicas    the desired replica count is less than the minimum replica count
Events:
  Type     Reason                        Age                    From                       Message
  ----     ------                        ----                   ----                       -------
  Warning  FailedComputeMetricsReplicas  8m3s (x3 over 9m33s)   horizontal-pod-autoscaler  invalid metrics (1 invalid out of 1), first error is: failed to get cpu resource metric value: failed to get cpu utilization: missing request for cpu in container nginx of Pod nginx-deployment-77bc6bd484-vnvtf
  Warning  FailedGetResourceMetric       7m48s (x6 over 10m)    horizontal-pod-autoscaler  failed to get cpu utilization: missing request for cpu in container nginx of Pod nginx-deployment-77bc6bd484-r7mr6
  Warning  FailedComputeMetricsReplicas  7m48s (x6 over 10m)    horizontal-pod-autoscaler  invalid metrics (1 invalid out of 1), first error is: failed to get cpu resource metric value: failed to get cpu utilization: missing request for cpu in container nginx of Pod nginx-deployment-77bc6bd484-r7mr6
  Warning  FailedGetResourceMetric       7m33s (x3 over 9m48s)  horizontal-pod-autoscaler  failed to get cpu utilization: missing request for cpu in container nginx of Pod nginx-deployment-77bc6bd484-dd9pq
  Warning  FailedComputeMetricsReplicas  7m33s (x3 over 9m48s)  horizontal-pod-autoscaler  invalid metrics (1 invalid out of 1), first error is: failed to get cpu resource metric value: failed to get cpu utilization: missing request for cpu in container nginx of Pod nginx-deployment-77bc6bd484-dd9pq
  Warning  FailedGetResourceMetric       7m18s (x4 over 9m33s)  horizontal-pod-autoscaler  failed to get cpu utilization: missing request for cpu in container nginx of Pod nginx-deployment-77bc6bd484-vnvtf
  Normal   SuccessfulRescale             4m48s (x3 over 10m)    horizontal-pod-autoscaler  New size: 3; reason: Current number of replicas above Spec.MaxReplicas
  Warning  FailedGetResourceMetric       4m33s                  horizontal-pod-autoscaler  failed to get cpu utilization: did not receive metrics for targeted pods (pods might be unready)
  Normal   SuccessfulRescale             4m18s (x2 over 5m3s)   horizontal-pod-autoscaler  New size: 1; reason: All metrics below target

controlplane ~ ➜  #12

controlplane ~ ➜  history
    1  #1
    2  #2
    3  k create -f /root/deployment.yml 
    4  k get deploy
    5  k get deploy -w
    6  #3
    7  cat /root/autoscale.yml
    8  #4
    9  k create -f /root/autoscale.yml
   10  kubectl autoscale deployment nginx-deployment --max=3 --cpu=80%
   11  #5
   12  #6
   13  #7
   14  k get deploy
   15  #8
   16  k get horizontalpodautoscalers nginx-deployment 
   17  k get hpa
   18  k describe hpa nginx-deployment 
   19  k describe deploy nginx-deployment 
   20  cat /root/deployment.yml 
   21  k apply -f /root/deployment.yml 
   22  k replace --force -f /root/deployment.yml 
   23  #11
   24  k describe hpa nginx-deployment 
   25  k describe hpa nginx-deployment | grep -i "ScalingReplicaSet"
   26  k describe hpa nginx-deployment | grep -i "ScalingReplicaSet" -C3
   27  k get hpa -owide
   28  k get hpa nginx-deployment -o wide
   29  k get hpa -oyaml
   30  k describe hpa nginx-deployment 
   31  #12
   32  history
```

# Modifying CPU resources in VPA
```cmd
             Welcome to the KodeKloud Hands-On lab                                                                                                                                                        
    __ ______  ____  ________ __ __    ____  __  ______ 
   / //_/ __ \/ __ \/ ____/ //_// /   / __ \/ / / / __ \
  / ,< / / / / / / / __/ / ,<  / /   / / / / / / / / / /
 / /| / /_/ / /_/ / /___/ /| |/ /___/ /_/ / /_/ / /_/ / 
/_/ |_\____/_____/_____/_/ |_/_____/\____/\____/_____/  
                                                        
                     All rights reserved                                                                                                                                                                  

controlplane ~ ➜  k describe vpa flask-app 
Name:         flask-app
Namespace:    default
Labels:       <none>
Annotations:  <none>
API Version:  autoscaling.k8s.io/v1
Kind:         VerticalPodAutoscaler
Metadata:
  Creation Timestamp:  2026-06-10T12:24:56Z
  Generation:          1
  Resource Version:    3012
  UID:                 b7f2b7bb-9888-4557-853c-b187fd93d804
Spec:
  Resource Policy:
    Container Policies:
      Container Name:  *
      Controlled Resources:
        cpu
      Max Allowed:
        Cpu:  1000m
      Min Allowed:
        Cpu:  100m
  Target Ref:
    API Version:  apps/v1
    Kind:         Deployment
    Name:         flask-app-4
  Update Policy:
    Update Mode:  Off
Status:
  Conditions:
    Last Transition Time:  2026-06-10T12:25:20Z
    Status:                True
    Type:                  RecommendationProvided
  Recommendation:
    Container Recommendations:
      Container Name:  flask-app-4
      Lower Bound:
        Cpu:  100m
      Target:
        Cpu:  100m
      Uncapped Target:
        Cpu:  25m
      Upper Bound:
        Cpu:  1
Events:       <none>

controlplane ~ ➜  echo "100m" > /root/target

controlplane ~ ➜  k describe vpa flask-app 
Name:         flask-app
Namespace:    default
Labels:       <none>
Annotations:  <none>
API Version:  autoscaling.k8s.io/v1
Kind:         VerticalPodAutoscaler
Metadata:
  Creation Timestamp:  2026-06-10T12:24:56Z
  Generation:          1
  Resource Version:    3196
  UID:                 b7f2b7bb-9888-4557-853c-b187fd93d804
Spec:
  Resource Policy:
    Container Policies:
      Container Name:  *
      Controlled Resources:
        cpu
      Max Allowed:
        Cpu:  1000m
      Min Allowed:
        Cpu:  100m
  Target Ref:
    API Version:  apps/v1
    Kind:         Deployment
    Name:         flask-app-4
  Update Policy:
    Update Mode:  Off
Status:
  Conditions:
    Last Transition Time:  2026-06-10T12:25:20Z
    Status:                True
    Type:                  RecommendationProvided
  Recommendation:
    Container Recommendations:
      Container Name:  flask-app-4
      Lower Bound:
        Cpu:  156m
      Target:
        Cpu:  476m
      Uncapped Target:
        Cpu:  476m
      Upper Bound:
        Cpu:  1
Events:       <none>

controlplane ~ ➜  echo "476m" > /root/target

controlplane ~ ➜  history
    1  k describe vpa flask-app 
    2  echo "100m" > /root/target
    3  k describe vpa flask-app 
    4  echo "476m" > /root/target
    5  history
```