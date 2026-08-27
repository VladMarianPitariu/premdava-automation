# Configuration drift task

The drift task is separate from monitoring/remediation and runs hourly.

```text
Semaphore schedule: every 60 minutes
        -> Windows runner under gmsaPremDava$
        -> Collect-HyperVSnapshot.ps1
        -> Compare-HyperVSnapshot.ps1
        -> report-only result
        -> Semaphore email notification when drift is detected
```

The first run creates the baseline. Subsequent runs compare the current Hyper-V configuration with the previous hourly snapshot.

Snapshots are stored on persistent runner storage, for example:

```text
C:\ProgramData\PremDava\Snapshots\node6\
  latest.json
  previous.json
  last-drift-report.json
```

The collector is read-only against Hyper-V. It records host facts, virtual switches, VM state/resources and virtual network adapters. Volatile values such as the capture timestamp are excluded from comparison.

Email notification must be configured in Semaphore after the report is validated. The gMSA executes the collector; it does not require its password to be stored in Semaphore.
