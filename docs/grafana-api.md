# Grafana API access

The monitoring playbook queries the Prometheus datasource through the Grafana proxy. This avoids exposing the Prometheus endpoint directly to Semaphore.

Configure these Semaphore environment variables in a protected Variable Group:

```text
GRAFANA_URL=https://grafana.premdava.internal
GRAFANA_PROMETHEUS_DS_UID=ffidfenffgyyoe
GRAFANA_TOKEN=<read-only Grafana service-account token>
GRAFANA_CA_PATH=/etc/premdava/premdava-root-ca.crt
```

The token must be stored as a secret and must not be committed to Git. The playbook uses the Grafana datasource proxy endpoint and runs in `report_only` mode.

The Grafana service account needs permission to query the Prometheus datasource. The runner must also trust the internal Grafana TLS certificate.
