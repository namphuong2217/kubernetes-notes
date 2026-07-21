# Question 7 — PriorityClass for Critical Workloads

## Background

There is an existing Deployment named **log-collector** in the **workloads** namespace.

The cluster already contains one or more **user-defined PriorityClasses**.

Your task is to create a new PriorityClass and configure the Deployment to use it.

---

## Tasks

1. Create a PriorityClass named:

   ```
   elevated-priority
   ```

2. Set its value to exactly **one less** than the **highest existing user-defined PriorityClass**.

3. Patch the existing Deployment:

   ```
   log-collector
   ```

   in namespace:

   ```
   workloads
   ```

4. Configure the Pod template to use:

   ```
   elevated-priority
   ```

---

## Validation

After completing the task, verify your solution:

```bash
./verify.sh
```