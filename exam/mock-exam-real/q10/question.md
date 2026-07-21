# Question 10 — Migrate Ingress to Gateway API

## Background

You have an existing web application exposed via an Ingress named **api-ingress**.

Migrate it to the Gateway API while keeping the existing HTTPS configuration.

A GatewayClass named **nginx-gw** is already installed.

---

## Tasks

- Create a Gateway named:

  ```
  api-gateway
  ```

  with hostname:

  ```
  api.gateway.local
  ```

  preserving the TLS/listener configuration from **api-ingress**.

- Create an HTTPRoute named:

  ```
  api-route
  ```

  with hostname:

  ```
  api.gateway.local
  ```

  preserving the routing rules from **api-ingress**.

---

## Validation

After completing the task, verify your solution:

```bash
./verify.sh
```