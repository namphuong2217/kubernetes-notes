Stress test
Chạy container có cmd cpu,
https://killercoda.com/chadmcrowell/course/cka/metrics-server
B1. k autoscale --help
B2. kubectl -n scaling-lab autoscale deployment web-api --min=2 --max=5 --cpu=60% --dry-run=client -o yaml > q5.yaml
B3. vi q5.yaml => Copy từ kubernetes.io
```cmd 
# 5 HPA with stabiliztion window
# Input: 
# Search https://kubernetes.io/docs/concepts/workloads/autoscaling/horizontal-pod-autoscale/
k explain hpa
k explain hpa.spec
k autoscale --help
k create ns scaling-lab
k create -n scaling-lab deployment web-api
k -n scaling-lab autoscale deploy web-api --min-2 --max=5 --cpu=60% --dry-run=client -o yaml > q5.yaml
vi q5.yaml
# Copy behavior from docs]

# Output: 
k get hpa -n scaling-lab web-api
k get hpa web-api -n -scaling-lab -o yaml | grep -A2 scaleDown

#7 Priority class
# Input: https://kubernetes.io/docs/concepts/scheduling-eviction/pod-priority-preemption/

k get deploy -o json # de dung patch

k api-resources | grep prior
k get priorityClasses --sort-by=.value
k get priorityClasses --sort-by=.value | tac
k create priorityClasses --help
echo $((90000 - 1))
k explain pod.spec | grep -i priority
k explain pod.spec.priorityClassName | grep -i priority
k explain deploy.spec.template.spec

```