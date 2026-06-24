kubectl create deployment --help
k get po --watch = k get po -w
kubectl explain pods --recursive
kubectl explain deployments.spec.selector
kubectl explain deployments.spec.selector --recursive
#1

k explain netpol.spec

kubectl run nginx --image=nginx --port=8080 --dry-run=client -o yaml # Ko chay that
cat q1.yaml

kubectl apply -f q1.yaml
kubectl get pod

kubectl describe pod <pod-name>
kubectl describe pod <pod-name> | grep -i 'image'

kubectl get pod -o wide
kubectl get nodes

kubectl describe pod webapp | grep -i 'image'

# Luu Pod lai truoc khi delete
kubectl get pod <pod-name> -o yaml > q11_webapp.yaml
kubectl delete pod

kubectl run redis --image=redis123  --dry-run=client -o yaml > q12.yaml
kubectl apply -f q12.yaml
vi q12.yaml
# Escape
:

history

# 2
#Q1 How many PODS exist on the system
k get replicaset.apps
#Q2
#Q3
k get replicaset.apps

# Q5
k describe rs new-replica-set | grep -i 'image'
k get replicaset.apps -o wide
# Q7
k describe rs new-replica-set -o wide
k describe pod <pod-name>
# Q8
k get rs -w # Watch state
k delete po <pod-name>
# Q9
4
# Q10
k apply -f replicaset-definitions-1.yaml
cat replicaset-definitions-1.yaml
Run the command: You can check for apiVersion of replicaset by command
 kubectl api-resources | grep replicaset

kubectl explain replicaset | grep VERSION and correct the apiVersion for ReplicaSet.

Then run the command: kubectl create -f /root/replicaset-definition-1.yaml

ls
vi replicaset-definitions-1.yaml
cat replicaset-definitions-1.yaml
vi q11.yaml
# paste content file tren vao
# doi v1 thanh apps/v1
:wq!
k apply -f q11.yaml
# Xem img.png

k delete rs replicaset-2

# Q14
k get rs
k edit rs new-replica-set
# sua image busybox

k get po -o wide
k delete pod <pod-name>
# k get rs -w (watch) will reflect changes in other terminal
# Go on deleting all PODs one by one

# Q15
k edit rs new-replicaset
# Sua file bang vim :wq

# Q16
k scale rs new-replica-set --replicas=5

k get deployment

k create deployment http-frontend --image=httpd:2.4-alpine --dry-run=client -o yaml > q11.yaml


k describe service kubernetes
Name:                     kubernetes
Namespace:                default
Labels:                   component=apiserver
                          provider=kubernetes
Annotations:              <none>
Selector:                 <none>
Type:                     ClusterIP
IP Family Policy:         SingleStack
IP Families:              IPv4
IP:                       10.43.0.1
IPs:                      10.43.0.1
Port:                     https  443/TCP
TargetPort:               6443/TCP
Endpoints:                10.244.23.164:6443
Session Affinity:         None
Internal Traffic Policy:  Cluster
Events:                   <none>

# Namespace
kubectl get ns --no-headers | wc -l
kubectl get pods --all-namespaces | grep blue
# Service full name
redis-db-service.dev.svc.cluster.local
kubectl run redis -l tier=db --image=redis:alpine
kubectl run redis --image=redis:alpine --dry-run=client -o yaml > redis-pod.yaml

Use the kubectl expose command to create a service for the redis pod.
kubectl expose pod redis --port=6379 --name=redis-service --type=ClusterIP
kubectl create deployment  webapp --image=kodekloud/webapp-color --replicas=3
kubectl create deployment redis-deploy --image=redis --replicas=2 -n dev-ns

kubectl run httpd --image=httpd:alpine --port=80 --expose
service/httpd created
pod/httpd created

k explain pod


controlplane ~ ➜  k explain pod
KIND:       Pod
VERSION:    v1

DESCRIPTION:
    Pod is a collection of containers that can run on a host. This resource is
    created by clients and scheduled onto hosts.

FIELDS:
  apiVersion    <string>
    APIVersion defines the versioned schema of this representation of an object.
    Servers should convert recognized schemas to the latest internal value, and
    may reject unrecognized values. More info:
    https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources

  kind  <string>
    Kind is a string value representing the REST resource this object
    represents. Servers may infer this from the endpoint the client submits
    requests to. Cannot be updated. In CamelCase. More info:
    https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds

  metadata      <ObjectMeta>
    Standard object's metadata. More info:
    https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata

  spec  <PodSpec>
    Specification of the desired behavior of the pod. More info:
    https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#spec-and-status

  status        <PodStatus>
    Most recently observed status of the pod. This data may not be up to date.
    Populated by the system. Read-only. More info:
    https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#spec-and-status



controlplane ~ ➜  k explain pod.spec.containers
KIND:       Pod
VERSION:    v1

FIELD: containers <[]Container>


DESCRIPTION:
    List of containers belonging to the pod. Containers cannot currently be
    added or removed. There must be at least one container in a Pod. Cannot be
    updated.
    A single application container that you want to run within a pod.

FIELDS:
  args  <[]string>
    Arguments to the entrypoint. The container image's CMD is used if this is
    not provided. Variable references $(VAR_NAME) are expanded using the
    container's environment. If a variable cannot be resolved, the reference in
    the input string will be unchanged. Double $$ are reduced to a single $,
    which allows for escaping the $(VAR_NAME) syntax: i.e. "$$(VAR_NAME)" will
    produce the string literal "$(VAR_NAME)". Escaped references will never be
    expanded, regardless of whether the variable exists or not. Cannot be
    updated. More info:
    https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/#running-a-command-in-a-shell

  command       <[]string>
    Entrypoint array. Not executed within a shell. The container image's
    ENTRYPOINT is used if this is not provided. Variable references $(VAR_NAME)
    are expanded using the container's environment. If a variable cannot be
    resolved, the reference in the input string will be unchanged. Double $$ are
    reduced to a single $, which allows for escaping the $(VAR_NAME) syntax:
    i.e. "$$(VAR_NAME)" will produce the string literal "$(VAR_NAME)". Escaped
    references will never be expanded, regardless of whether the variable exists
    or not. Cannot be updated. More info:
    https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/#running-a-command-in-a-shell

  env   <[]EnvVar>
    List of environment variables to set in the container. Cannot be updated.

  envFrom       <[]EnvFromSource>
    List of sources to populate environment variables in the container. The keys
    defined within a source may consist of any printable ASCII characters except
    '='. When a key exists in multiple sources, the value associated with the
    last source will take precedence. Values defined by an Env with a duplicate
    key will take precedence. Cannot be updated.

  image <string>
    Container image name. More info:
    https://kubernetes.io/docs/concepts/containers/images This field is optional
    to allow higher level config management to default or override container
    images in workload controllers like Deployments and StatefulSets.

  imagePullPolicy       <string>
  enum: Always, IfNotPresent, Never
    Image pull policy. One of Always, Never, IfNotPresent. Defaults to Always if
    :latest tag is specified, or IfNotPresent otherwise. Cannot be updated. More
    info: https://kubernetes.io/docs/concepts/containers/images#updating-images

    Possible enum values:
     - `"Always"` means that kubelet always attempts to pull the latest image.
    Container will fail If the pull fails.
     - `"IfNotPresent"` means that kubelet pulls if the image isn't present on
    disk. Container will fail if the image isn't present and the pull fails.
     - `"Never"` means that kubelet never pulls an image, but only uses a local
    image. Container will fail if the image isn't present

  lifecycle     <Lifecycle>
    Actions that the management system should take in response to container
    lifecycle events. Cannot be updated.

  livenessProbe <Probe>
    Periodic probe of container liveness. Container will be restarted if the
    probe fails. Cannot be updated. More info:
    https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes

  name  <string> -required-
    Name of the container specified as a DNS_LABEL. Each container in a pod must
    have a unique name (DNS_LABEL). Cannot be updated.

  ports <[]ContainerPort>
    List of ports to expose from the container. Not specifying a port here DOES
    NOT prevent that port from being exposed. Any port which is listening on the
    default "0.0.0.0" address inside a container will be accessible from the
    network. Modifying this array with strategic merge patch may corrupt the
    data. For more information See
    https://github.com/kubernetes/kubernetes/issues/108255. Cannot be updated.

  readinessProbe        <Probe>
    Periodic probe of container service readiness. Container will be removed
    from service endpoints if the probe fails. Cannot be updated. More info:
    https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes

  resizePolicy  <[]ContainerResizePolicy>
    Resources resize policy for the container. This field cannot be set on
    ephemeral containers.

  resources     <ResourceRequirements>
    Compute Resources required by this container. Cannot be updated. More info:
    https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/

  restartPolicy <string>
    RestartPolicy defines the restart behavior of individual containers in a
    pod. This overrides the pod-level restart policy. When this field is not
    specified, the restart behavior is defined by the Pod's restart policy and
    the container type. Additionally, setting the RestartPolicy as "Always" for
    the init container will have the following effect: this init container will
    be continually restarted on exit until all regular containers have
    terminated. Once all regular containers have completed, all init containers
    with restartPolicy "Always" will be shut down. This lifecycle differs from
    normal init containers and is often referred to as a "sidecar" container.
    Although this init container still starts in the init container sequence, it
    does not wait for the container to complete before proceeding to the next
    init container. Instead, the next init container starts immediately after
    this init container is started, or after any startupProbe has successfully
    completed.

  restartPolicyRules    <[]ContainerRestartRule>
    Represents a list of rules to be checked to determine if the container
    should be restarted on exit. The rules are evaluated in order. Once a rule
    matches a container exit condition, the remaining rules are ignored. If no
    rule matches the container exit condition, the Container-level restart
    policy determines the whether the container is restarted or not. Constraints
    on the rules: - At most 20 rules are allowed. - Rules can have the same
    action. - Identical rules are not forbidden in validations. When rules are
    specified, container MUST set RestartPolicy explicitly even it if matches
    the Pod's RestartPolicy.

  securityContext       <SecurityContext>
    SecurityContext defines the security options the container should be run
    with. If set, the fields of SecurityContext override the equivalent fields
    of PodSecurityContext. More info:
    https://kubernetes.io/docs/tasks/configure-pod-container/security-context/

  startupProbe  <Probe>
    StartupProbe indicates that the Pod has successfully initialized. If
    specified, no other probes are executed until this completes successfully.
    If this probe fails, the Pod will be restarted, just as if the livenessProbe
    failed. This can be used to provide different probe parameters at the
    beginning of a Pod's lifecycle, when it might take a long time to load data
    or warm a cache, than during steady-state operation. This cannot be updated.
    More info:
    https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes

  stdin <boolean>
    Whether this container should allocate a buffer for stdin in the container
    runtime. If this is not set, reads from stdin in the container will always
    result in EOF. Default is false.

  stdinOnce     <boolean>
    Whether the container runtime should close the stdin channel after it has
    been opened by a single attach. When stdin is true the stdin stream will
    remain open across multiple attach sessions. If stdinOnce is set to true,
    stdin is opened on container start, is empty until the first client attaches
    to stdin, and then remains open and accepts data until the client
    disconnects, at which time stdin is closed and remains closed until the
    container is restarted. If this flag is false, a container processes that
    reads from stdin will never receive an EOF. Default is false

  terminationMessagePath        <string>
    Optional: Path at which the file to which the container's termination
    message will be written is mounted into the container's filesystem. Message
    written is intended to be brief final status, such as an assertion failure
    message. Will be truncated by the node if greater than 4096 bytes. The total
    message length across all containers will be limited to 12kb. Defaults to
    /dev/termination-log. Cannot be updated.

  terminationMessagePolicy      <string>
  enum: FallbackToLogsOnError, File
    Indicate how the termination message should be populated. File will use the
    contents of terminationMessagePath to populate the container status message
    on both success and failure. FallbackToLogsOnError will use the last chunk
    of container log output if the termination message file is empty and the
    container exited with an error. The log output is limited to 2048 bytes or
    80 lines, whichever is smaller. Defaults to File. Cannot be updated.

    Possible enum values:
     - `"FallbackToLogsOnError"` will read the most recent contents of the
    container logs for the container status message when the container exits
    with an error and the terminationMessagePath has no contents.
     - `"File"` is the default behavior and will set the container status
    message to the contents of the container's terminationMessagePath when the
    container exits.

  tty   <boolean>
    Whether this container should allocate a TTY for itself, also requires
    'stdin' to be true. Default is false.

  volumeDevices <[]VolumeDevice>
    volumeDevices is the list of block devices to be used by the container.

  volumeMounts  <[]VolumeMount>
    Pod volumes to mount into the container's filesystem. Cannot be updated.

  workingDir    <string>
    Container's working directory. If not specified, the container runtime's
    default will be used, which might be configured in the container image.
    Cannot be updated.

ontrolplane ~ ➜  k explain pod.spec
KIND:       Pod
VERSION:    v1

FIELD: spec <PodSpec>


DESCRIPTION:
    Specification of the desired behavior of the pod. More info:
    https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#spec-and-status
    PodSpec is a description of a pod.

FIELDS:
  activeDeadlineSeconds <integer>
    Optional duration in seconds the pod may be active on the node relative to
    StartTime before the system will actively try to mark it failed and kill
    associated containers. Value must be a positive integer.

  affinity      <Affinity>
    If specified, the pod's scheduling constraints

  automountServiceAccountToken  <boolean>
    AutomountServiceAccountToken indicates whether a service account token
    should be automatically mounted.

  containers    <[]Container> -required-
    List of containers belonging to the pod. Containers cannot currently be
    added or removed. There must be at least one container in a Pod. Cannot be
    updated.

  dnsConfig     <PodDNSConfig>
    Specifies the DNS parameters of a pod. Parameters specified here will be
    merged to the generated DNS configuration based on DNSPolicy.

  dnsPolicy     <string>
  enum: ClusterFirst, ClusterFirstWithHostNet, Default, None
    Set DNS policy for the pod. Defaults to "ClusterFirst". Valid values are
    'ClusterFirstWithHostNet', 'ClusterFirst', 'Default' or 'None'. DNS
    parameters given in DNSConfig will be merged with the policy selected with
    DNSPolicy. To have DNS options set along with hostNetwork, you have to
    specify DNS policy explicitly to 'ClusterFirstWithHostNet'.

    Possible enum values:
     - `"ClusterFirst"` indicates that the pod should use cluster DNS first
    unless hostNetwork is true, if it is available, then fall back on the
    default (as determined by kubelet) DNS settings.
     - `"ClusterFirstWithHostNet"` indicates that the pod should use cluster DNS
    first, if it is available, then fall back on the default (as determined by
    kubelet) DNS settings.
     - `"Default"` indicates that the pod should use the default (as determined
    by kubelet) DNS settings.
     - `"None"` indicates that the pod should use empty DNS settings. DNS
    parameters such as nameservers and search paths should be defined via
    DNSConfig.

  enableServiceLinks    <boolean>
    EnableServiceLinks indicates whether information about services should be
    injected into pod's environment variables, matching the syntax of Docker
    links. Optional: Defaults to true.

  ephemeralContainers   <[]EphemeralContainer>
    List of ephemeral containers run in this pod. Ephemeral containers may be
    run in an existing pod to perform user-initiated actions such as debugging.
    This list cannot be specified when creating a pod, and it cannot be modified
    by updating the pod spec. In order to add an ephemeral container to an
    existing pod, use the pod's ephemeralcontainers subresource.

  hostAliases   <[]HostAlias>
    HostAliases is an optional list of hosts and IPs that will be injected into
    the pod's hosts file if specified.

  hostIPC       <boolean>
    Use the host's ipc namespace. Optional: Default to false.

  hostNetwork   <boolean>
    Host networking requested for this pod. Use the host's network namespace.
    When using HostNetwork you should specify ports so the scheduler is aware.
    When `hostNetwork` is true, specified `hostPort` fields in port definitions
    must match `containerPort`, and unspecified `hostPort` fields in port
    definitions are defaulted to match `containerPort`. Default to false.

  hostPID       <boolean>
    Use the host's pid namespace. Optional: Default to false.

  hostUsers     <boolean>
    Use the host's user namespace. Optional: Default to true. If set to true or
    not present, the pod will be run in the host user namespace, useful for when
    the pod needs a feature only available to the host user namespace, such as
    loading a kernel module with CAP_SYS_MODULE. When set to false, a new userns
    is created for the pod. Setting false is useful for mitigating container
    breakout vulnerabilities even allowing users to run their containers as root
    without actually having root privileges on the host. This field is
    alpha-level and is only honored by servers that enable the
    UserNamespacesSupport feature.

  hostname      <string>
    Specifies the hostname of the Pod If not specified, the pod's hostname will
    be set to a system-defined value.

  hostnameOverride      <string>
    HostnameOverride specifies an explicit override for the pod's hostname as
    perceived by the pod. This field only specifies the pod's hostname and does
    not affect its DNS records. When this field is set to a non-empty string: -
    It takes precedence over the values set in `hostname` and `subdomain`. - The
    Pod's hostname will be set to this value. - `setHostnameAsFQDN` must be nil
    or set to false. - `hostNetwork` must be set to false.

    This field must be a valid DNS subdomain as defined in RFC 1123 and contain
    at most 64 characters. Requires the HostnameOverride feature gate to be
    enabled.

  imagePullSecrets      <[]LocalObjectReference>
    ImagePullSecrets is an optional list of references to secrets in the same
    namespace to use for pulling any of the images used by this PodSpec. If
    specified, these secrets will be passed to individual puller implementations
    for them to use. More info:
    https://kubernetes.io/docs/concepts/containers/images#specifying-imagepullsecrets-on-a-pod

  initContainers        <[]Container>
    List of initialization containers belonging to the pod. Init containers are
    executed in order prior to containers being started. If any init container
    fails, the pod is considered to have failed and is handled according to its
    restartPolicy. The name for an init container or normal container must be
    unique among all containers. Init containers may not have Lifecycle actions,
    Readiness probes, Liveness probes, or Startup probes. The
    resourceRequirements of an init container are taken into account during
    scheduling by finding the highest request/limit for each resource type, and
    then using the max of that value or the sum of the normal containers. Limits
    are applied to init containers in a similar fashion. Init containers cannot
    currently be added or removed. Cannot be updated. More info:
    https://kubernetes.io/docs/concepts/workloads/pods/init-containers/

  nodeName      <string>
    NodeName indicates in which node this pod is scheduled. If empty, this pod
    is a candidate for scheduling by the scheduler defined in schedulerName.
    Once this field is set, the kubelet for this node becomes responsible for
    the lifecycle of this pod. This field should not be used to express a desire
    for the pod to be scheduled on a specific node.
    https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodename

  nodeSelector  <map[string]string>
    NodeSelector is a selector which must be true for the pod to fit on a node.
    Selector which must match a node's labels for the pod to be scheduled on
    that node. More info:
    https://kubernetes.io/docs/concepts/configuration/assign-pod-node/

  os    <PodOS>
    Specifies the OS of the containers in the pod. Some pod and container fields
    are restricted if this is set.

    If the OS field is set to linux, the following fields must be unset:
    -securityContext.windowsOptions

    If the OS field is set to windows, following fields must be unset: -
    spec.hostPID - spec.hostIPC - spec.hostUsers - spec.resources -
    spec.securityContext.appArmorProfile - spec.securityContext.seLinuxOptions -
    spec.securityContext.seccompProfile - spec.securityContext.fsGroup -
    spec.securityContext.fsGroupChangePolicy - spec.securityContext.sysctls -
    spec.shareProcessNamespace - spec.securityContext.runAsUser -
    spec.securityContext.runAsGroup - spec.securityContext.supplementalGroups -
    spec.securityContext.supplementalGroupsPolicy -
    spec.containers[*].securityContext.appArmorProfile -
    spec.containers[*].securityContext.seLinuxOptions -
    spec.containers[*].securityContext.seccompProfile -
    spec.containers[*].securityContext.capabilities -
    spec.containers[*].securityContext.readOnlyRootFilesystem -
    spec.containers[*].securityContext.privileged -
    spec.containers[*].securityContext.allowPrivilegeEscalation -
    spec.containers[*].securityContext.procMount -
    spec.containers[*].securityContext.runAsUser -
    spec.containers[*].securityContext.runAsGroup

  overhead      <map[string]Quantity>
    Overhead represents the resource overhead associated with running a pod for
    a given RuntimeClass. This field will be autopopulated at admission time by
    the RuntimeClass admission controller. If the RuntimeClass admission
    controller is enabled, overhead must not be set in Pod create requests. The
    RuntimeClass admission controller will reject Pod create requests which have
    the overhead already set. If RuntimeClass is configured and selected in the
    PodSpec, Overhead will be set to the value defined in the corresponding
    RuntimeClass, otherwise it will remain unset and treated as zero. More info:
    https://git.k8s.io/enhancements/keps/sig-node/688-pod-overhead/README.md

  preemptionPolicy      <string>
  enum: Never, PreemptLowerPriority
    PreemptionPolicy is the Policy for preempting pods with lower priority. One
    of Never, PreemptLowerPriority. Defaults to PreemptLowerPriority if unset.

    Possible enum values:
     - `"Never"` means that pod never preempts other pods with lower priority.
     - `"PreemptLowerPriority"` means that pod can preempt other pods with lower
    priority.

  priority      <integer>
    The priority value. Various system components use this field to find the
    priority of the pod. When Priority Admission Controller is enabled, it
    prevents users from setting this field. The admission controller populates
    this field from PriorityClassName. The higher the value, the higher the
    priority.

  priorityClassName     <string>
    If specified, indicates the pod's priority. "system-node-critical" and
    "system-cluster-critical" are two special keywords which indicate the
    highest priorities with the former being the highest priority. Any other
    name must be defined by creating a PriorityClass object with that name. If
    not specified, the pod priority will be default or zero if there is no
    default.

  readinessGates        <[]PodReadinessGate>
    If specified, all readiness gates will be evaluated for pod readiness. A pod
    is ready when all its containers are ready AND all conditions specified in
    the readiness gates have status equal to "True" More info:
    https://git.k8s.io/enhancements/keps/sig-network/580-pod-readiness-gates

  resourceClaims        <[]PodResourceClaim>
    ResourceClaims defines which ResourceClaims must be allocated and reserved
    before the Pod is allowed to start. The resources will be made available to
    those containers which consume them by name.

    This is a stable field but requires that the DynamicResourceAllocation
    feature gate is enabled.

    This field is immutable.

  resources     <ResourceRequirements>
    Resources is the total amount of CPU and Memory resources required by all
    containers in the pod. It supports specifying Requests and Limits for "cpu",
    "memory" and "hugepages-" resource names only. ResourceClaims are not
    supported.

    This field enables fine-grained control over resource allocation for the
    entire pod, allowing resource sharing among containers in a pod.

    This is an alpha field and requires enabling the PodLevelResources feature
    gate.

  restartPolicy <string>
  enum: Always, Never, OnFailure
    Restart policy for all containers within the pod. One of Always, OnFailure,
    Never. In some contexts, only a subset of those values may be permitted.
    Default to Always. More info:
    https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#restart-policy

    Possible enum values:
     - `"Always"`
     - `"Never"`
     - `"OnFailure"`

  runtimeClassName      <string>
    RuntimeClassName refers to a RuntimeClass object in the node.k8s.io group,
    which should be used to run this pod.  If no RuntimeClass resource matches
    the named class, the pod will not be run. If unset or empty, the "legacy"
    RuntimeClass will be used, which is an implicit class with an empty
    definition that uses the default runtime handler. More info:
    https://git.k8s.io/enhancements/keps/sig-node/585-runtime-class

  schedulerName <string>
    If specified, the pod will be dispatched by specified scheduler. If not
    specified, the pod will be dispatched by default scheduler.

  schedulingGates       <[]PodSchedulingGate>
    SchedulingGates is an opaque list of values that if specified will block
    scheduling the pod. If schedulingGates is not empty, the pod will stay in
    the SchedulingGated state and the scheduler will not attempt to schedule the
    pod.

    SchedulingGates can only be set at pod creation time, and be removed only
    afterwards.

  securityContext       <PodSecurityContext>
    SecurityContext holds pod-level security attributes and common container
    settings. Optional: Defaults to empty.  See type description for default
    values of each field.

  serviceAccount        <string>
    DeprecatedServiceAccount is a deprecated alias for ServiceAccountName.
    Deprecated: Use serviceAccountName instead.

  serviceAccountName    <string>
    ServiceAccountName is the name of the ServiceAccount to use to run this pod.
    More info:
    https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/

  setHostnameAsFQDN     <boolean>
    If true the pod's hostname will be configured as the pod's FQDN, rather than
    the leaf name (the default). In Linux containers, this means setting the
    FQDN in the hostname field of the kernel (the nodename field of struct
    utsname). In Windows containers, this means setting the registry value of
    hostname for the registry key
    HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Services\\Tcpip\\Parameters
    to FQDN. If a pod does not have FQDN, this has no effect. Default to false.

  shareProcessNamespace <boolean>
    Share a single process namespace between all of the containers in a pod.
    When this is set containers will be able to view and signal processes from
    other containers in the same pod, and the first process in each container
    will not be assigned PID 1. HostPID and ShareProcessNamespace cannot both be
    set. Optional: Default to false.

  subdomain     <string>
    If specified, the fully qualified Pod hostname will be
    "<hostname>.<subdomain>.<pod namespace>.svc.<cluster domain>". If not
    specified, the pod will not have a domainname at all.

  terminationGracePeriodSeconds <integer>
    Optional duration in seconds the pod needs to terminate gracefully. May be
    decreased in delete request. Value must be non-negative integer. The value
    zero indicates stop immediately via the kill signal (no opportunity to shut
    down). If this value is nil, the default grace period will be used instead.
    The grace period is the duration in seconds after the processes running in
    the pod are sent a termination signal and the time when the processes are
    forcibly halted with a kill signal. Set this value longer than the expected
    cleanup time for your process. Defaults to 30 seconds.

  tolerations   <[]Toleration>
    If specified, the pod's tolerations.

  topologySpreadConstraints     <[]TopologySpreadConstraint>
    TopologySpreadConstraints describes how a group of pods ought to spread
    across topology domains. Scheduler will schedule pods in a way which abides
    by the constraints. All topologySpreadConstraints are ANDed.

  volumes       <[]Volume>
    List of volumes that can be mounted by containers belonging to the pod. More
    info: https://kubernetes.io/docs/concepts/storage/volumes

  workloadRef   <WorkloadReference>
    WorkloadRef provides a reference to the Workload object that this Pod
    belongs to. This field is used by the scheduler to identify the PodGroup and
    apply the correct group scheduling policies. The Workload object referenced
    by this field may not exist at the time the Pod is created. This field is
    immutable, but a Workload object with the same name may be recreated with
    different policies. Doing this during pod scheduling may result in the
    placement not conforming to the expected policies.



controlplane ~ ➜


controlplane ~ ✖ k explain deploy.spec
GROUP:      apps
KIND:       Deployment
VERSION:    v1

FIELD: spec <DeploymentSpec>


DESCRIPTION:
    Specification of the desired behavior of the Deployment.
    DeploymentSpec is the specification of the desired behavior of the
    Deployment.

FIELDS:
  minReadySeconds       <integer>
    Minimum number of seconds for which a newly created pod should be ready
    without any of its container crashing, for it to be considered available.
    Defaults to 0 (pod will be considered available as soon as it is ready)

  paused        <boolean>
    Indicates that the deployment is paused.

  progressDeadlineSeconds       <integer>
    The maximum time in seconds for a deployment to make progress before it is
    considered to be failed. The deployment controller will continue to process
    failed deployments and a condition with a ProgressDeadlineExceeded reason
    will be surfaced in the deployment status. Note that progress will not be
    estimated during the time a deployment is paused. Defaults to 600s.

  replicas      <integer>
    Number of desired pods. This is a pointer to distinguish between explicit
    zero and not specified. Defaults to 1.

  revisionHistoryLimit  <integer>
    The number of old ReplicaSets to retain to allow rollback. This is a pointer
    to distinguish between explicit zero and not specified. Defaults to 10.

  selector      <LabelSelector> -required-
    Label selector for pods. Existing ReplicaSets whose pods are selected by
    this will be the ones affected by this deployment. It must match the pod
    template's labels.

  strategy      <DeploymentStrategy>
    The deployment strategy to use to replace existing pods with new ones.

  template      <PodTemplateSpec> -required-
    Template describes the pods that will be created. The only allowed
    template.spec.restartPolicy value is "Always".

