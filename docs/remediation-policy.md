# Remediation policy

## Endpoint failure flow

```text
Probe failure
    -> Grafana Pending for 5 minutes
    -> Semaphore service-remediation job
    -> pre-check
    -> restart service once
    -> post-check
        -> UP: recovery and close alert
        -> DOWN: notify owner and request approval
    -> approved VM restart
    -> final post-check
        -> UP: recovery and close alert
        -> DOWN: manual escalation
```

## Policy levels

| Situation | Action |
|---|---|
| Endpoint unavailable for less than 5 minutes | No action |
| Endpoint unavailable for at least 5 minutes | Restart the mapped service once |
| Service recovers | Record recovery and close alert |
| Service does not recover | Notify responsible person |
| Manual approval received | Restart the mapped VM |
| VM remains unavailable | Escalate manually |

## Safety controls

- Grafana alert rule uses `for: 5m` for transient failures.
- Only one automatic service restart is attempted.
- Cooldown is 30–60 minutes per target.
- A daily restart limit is enforced per VM and service.
- Endpoint, service, VM and Hyper-V host must resolve through an allowlist.
- Pre-check and post-check results are required.
- DNS, network and storage symptoms block automatic restart.
- VM restart requires a separate manually approved workflow.
- Audit records include alert ID, Semaphore job ID, host, VM, service, action and result.

The initial implementation remains `report_only` until node6 connectivity, the Windows runner and the target mapping are validated.
