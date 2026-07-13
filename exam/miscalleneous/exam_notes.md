
1. Review UI, Options
- Task, Hint, Solution, AI Assistant
- Open additional terminal

2. Cánh đánh dấu #Q1 - How many POD exist on the system?

3. CMD quan trọng
   kubectl api-resources --help
   k run --help
   kubectl run nginx --image=nginx --dry-run=client  -o yaml > q1_2.yaml
   kubectl describe pod newpods-9pwc7 | grep -i 'image'
   kubectl get pod --watch (-w)
   kubectl get pod -o wide

4. Tips
   Kubernetes is primarily event-driven, not polling-driven.
   WATCH for changes in realtime, then reconcile periodically.
   Kubernetes components usually LIST once,
   then continuously WATCH for changes.
   Kubernetes WATCH is a long-lived HTTP streaming connection,
   not periodic polling.
   WATCH behaves more like Server-Sent Events than WebSockets.
   https://kubernetes.io/docs/reference/using-api/api-concepts/#efficient-detection-of-changes

5. English / Keyword
   Reconcile: Đối soát, điều chỉnh cho phù hợp.
   while true:
   observe current state
   compare desired state
   take action if different

6. Image Kubernetes Image Pull Process. In Kubernetes, the Image Pull Process… | by Kandaanusha | Medium

```cmd
kubectl scale rs --help
# CLick chuot trai 2 cai la tu copy
```




The correct answer is Shows all nested fields recursively in a single output

The --recursive flag is useful for getting a complete view of a resource's structure:

kubectl explain pod.spec --recursive
This will show:

All top-level fields under spec
All nested fields within those fields
The complete hierarchy in one output
Compare this to the default behavior:

kubectl explain pod.spec
This only shows the immediate fields under spec, requiring you to drill down manually to see nested fields.

Use --recursive when:

You want to see the complete structure quickly
You're searching for a specific field but don't know its exact path
You want to understand the full scope of available options