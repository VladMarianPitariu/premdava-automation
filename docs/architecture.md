# Architecture

Grafana and Prometheus are centralized on `infra5` on node 5. Blackbox Exporter provides endpoint and host health signals. Semaphore receives approved alert events and starts controlled jobs.

Each Hyper-V host will have a Windows runner capable of executing the approved local operations under `gmsaPremDava$`. Ubuntu VM operations use SSH and Ansible with the existing golden-image conventions.

## Remediation flow

```text
Blackbox / Prometheus
        -> Grafana Alerting
        -> validated Semaphore trigger
        -> allowlisted job
        -> Windows runner
        -> Hyper-V or VM operation
        -> post-remediation verification
        -> audit result
```

The first pilot target is node 7. The implementation must remain host-independent so it can later be applied to all Hyper-V nodes.

## Allowed operations

- `get_vm_status`
- `start_vm`
- `stop_vm`
- `restart_vm`
- `get_service_status`
- `restart_service`
- `check_configuration`

No PowerShell command received from a webhook may be executed directly.
