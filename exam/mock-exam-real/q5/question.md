# Question 5 — Horizontal Pod Autoscaler with Stabilization Window

## Background

An existing Deployment named **web-api-deployment** is running in the **scaling-lab** namespace.

Your task is to create a HorizontalPodAutoscaler for this Deployment.

---

## Tasks

1. Create a HorizontalPodAutoscaler named:

   ```
   web-api
   ```

2. Target the existing Deployment:

   ```
   web-api-deployment
   ```

3. Configure the HorizontalPodAutoscaler to maintain:

   ```
   60% average CPU utilization per Pod
   ```

4. Configure:

   - Minimum replicas:

     ```
     2
     ```

   - Maximum replicas:

     ```
     5
     ```

5. Configure the downscale stabilization window to:

   ```
   45 seconds
   ```

---

## Validation

After completing the task, verify your solution:

```bash
./verify.sh
```