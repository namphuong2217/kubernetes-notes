# Câu 16 — Restrict an nginx Service to TLSv1.2 Only

## Background

There is a Deployment in the **secure-web** namespace using a ConfigMap **web-tls-cfg** that currently allows both **TLSv1.2** and **TLSv1.3**, plus a Secret for the TLS certificate.

A Service **secure-web** in the same namespace exposes it.

## Tasks

- Update the ConfigMap so only **TLSv1.2** is accepted.

- Map the Service's ClusterIP to the hostname **tls-check.k8s.local** in **/etc/hosts**.

- Verify:

```bash
curl -vk --tlsv1.3 https://tls-check.k8s.local
```

must fail.

```bash
curl -vk --tls-max 1.2 https://tls-check.k8s.local
```

must succeed.

## Validation

```bash
./verify.sh
```