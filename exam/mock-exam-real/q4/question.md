# Question 4 — Fair Resource Allocation Across Pods

## Background

You are managing a Deployment named **blog-app** in the **eager-fox** namespace.

The Deployment currently runs **5 replicas**.

Your task is to adjust the Pod resource requests and limits so that the workload shares the node resources fairly while leaving enough capacity for system components.

---

## Tasks

1. Scale the Deployment down to:

   ```
   0 replicas
   ```

2. Check the node allocatable CPU and memory.

3. Divide the allocatable resources fairly across all **5 Pods**.

4. Leave enough overhead so the node remains stable.

5. Configure identical resource requests and limits for:

   - Init container
   - Main container

6. Scale the Deployment back to:

   ```
   5 replicas
   ```

---

## Validation

After completing the task, verify your solution:

```bash
./verify.sh
```