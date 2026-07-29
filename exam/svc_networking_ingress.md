# Kubernetes Networking Summary

## Services

-   **ClusterIP**: Default; reachable only inside the cluster.
-   **NodePort**:
    -   Exposes a Service on the same high port (30000--32767) on
        **every node**.
    -   `kube-proxy` installs forwarding rules on each node.
    -   You can reach the Service via **any node IP + NodePort**, even
        if the Pod runs on another node.
-   **LoadBalancer**: Creates an external load balancer (cloud
    environments).

### Service Ports

-   `port`: Service port.
-   `targetPort`: Container port.
-   `nodePort`: External port on every node (NodePort only).

Example flow:

``` text
Client
   |
NodeIP:31753
   |
kube-proxy
   |
Service:9090
   |
Pod:9090
```

## Ingress

-   Layer 7 (HTTP/HTTPS) routing.
-   Routes by **host** and/or **path**.
-   Requires an **Ingress Controller**.
-   Backend points to a **Service**, not directly to Pods.

Example:

``` yaml
rules:
- host: echo.example.local
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

Testing:

``` bash
curl -H "Host: echo.example.local" http://<INGRESS-IP>/ping
```

## Gateway API

Gateway API separates infrastructure from routing.

### Gateway

-   Defines listeners (ports/protocols/TLS).
-   Similar to the "entry point" of an Ingress controller.

### HTTPRoute

-   Defines host/path matching.
-   References a Gateway with `parentRefs`.
-   Forwards to Services via `backendRefs`.

Example:

``` yaml
Gateway listener:
  protocol: HTTPS
  port: 443

HTTPRoute backend:
  service: api-service
  port: 80
```

### Important Distinction

-   **Gateway listener port** = Client → Gateway
-   **backendRef port** = Gateway → Service
-   **targetPort** = Service → Pod

These are independent.

## Node Allocatable

-   Every node has its own `status.allocatable`.
-   `kubectl get node -o yaml` returns a NodeList (`items:`), each with
    its own allocatable section.
-   For scheduling calculations, use the allocatable resources of the
    node where Pods will run (often the worker node because the
    control-plane node is tainted).

## Resource Requests vs Limits

-   **Requests** determine scheduling.
-   **Limits** restrict runtime usage.
-   If Pods remain Pending due to insufficient resources, reduce
    **requests** (and set matching limits if the task requires identical
    values).

## Sidecar / Init Container Notes

-   A sidecar implemented as an init container with
    `restartPolicy: Always` may start before the application creates a
    log file.
-   Robust command:

``` sh
touch /var/log/apache-web.log && exec tail -f /var/log/apache-web.log
```

-   `>>` creates a file automatically if it does not exist, which
    explains why `tail` may sometimes succeed without an explicit
    `touch` (startup timing/race).

## kubectl Tips

-   Stop a blocking command (e.g. `kubectl rollout status`,
    `kubectl logs -f`) with **Ctrl+C**.
-   Apply manifests should **not** include server-managed fields:
    -   `status`
    -   `resourceVersion`
    -   `uid`
    -   `generation`
    -   `managedFields`
    -   `creationTimestamp`

## Exam Tips

-   Test NodePort with:
    -   `curl http://<NodeIP>:<NodePort>/...`
-   Test Ingress with:
    -   `curl -H "Host: <hostname>" http://<Ingress-IP>/...`
-   Test HTTPS Gateway with:
    -   `curl -k -H "Host: <hostname>" https://<Gateway-IP>`

# Examples

```cmd
controlplane ~ ✖ kubectl describe deployment web-front -n svc-lab | grep -i Port
    Port:          3000/TCP
    Host Port:     0/TCP

controlplane ~ ➜  kubectl get svc web-front-svc -n svc-lab

kubectl get endpoints web-front-svc -n svc-lab
NAME            TYPE       CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
web-front-svc   NodePort   10.43.135.67   <none>        3000:32457/TCP   3m12s
Warning: v1 Endpoints is deprecated in v1.33+; use discovery.k8s.io/v1 EndpointSlice
NAME            ENDPOINTS         AGE
web-front-svc   10.22.0.12:3000   3m12s
```
The key thing to understand is that:

ENDPOINTS
10.22.0.12:3000

is not the Service IP. It is the Pod IP and Pod port behind the Service.

Let's break down what you have.

Your Deployment
Deployment
    |
    v
Pod
IP: 10.22.0.12
Container Port: 3000

The Pod is running an nginx container listening on:

10.22.0.12:3000
Your Service
NAME            TYPE       CLUSTER-IP     PORT(S)
web-front-svc   NodePort   10.43.135.67   3000:32457

Meaning:

Service IP : 10.43.135.67
Service Port : 3000

NodePort : 32457

The Service forwards requests to:

10.22.0.12:3000

which is why the Endpoints object shows

10.22.0.12:3000
What can you do with 10.22.0.12:3000?

Since it is a Pod IP, you can access it from inside the cluster.

For example, create a temporary Pod:

kubectl run test \
  --image=curlimages/curl \
  --rm -it -- sh

Inside:

curl http://10.22.0.12:3000

or

wget -qO- http://10.22.0.12:3000

This talks directly to the Pod, bypassing the Service.