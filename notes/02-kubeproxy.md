The kube-proxy service running on each node is the communication mechanism
of a Kubernetes service. A service is another resource type in Kubernetes, and it is
responsible for allocating traffic to the various pods within that service. We’ll discuss
services in depth in chapter 6. These are basic network rules for the node to follow in
the event that traffic needs to get to the pods in Kubernetes. There’s a fascinating
video that describes this in greater detail called “Life of a Packet.” I highly encourage
you to watch it here: https://youtu.be/0Omvgd7Hg1I.