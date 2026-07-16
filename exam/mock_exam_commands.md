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


```