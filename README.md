IT Incident Response \& Remediation Automation



A PowerShell-based IT operations project that monitors disk space, detects simulated incidents, classifies severity, executes controlled remediation tests, and records audit logs. Rundeck is used to orchestrate the workflow.



Project Overview



This project demonstrates a local Windows IT operations workflow: monitor disk space, identify potential incidents, determine the appropriate response, and record the results.



Remediation testing is restricted to a dedicated Test-Lab directory. Low-disk-space incidents can be simulated without changing actual disk usage.



Objectives



Monitor available disk space on the Windows C: drive.



Classify disk status using a 15 GB threshold.



Assign severity levels to detected conditions.



Simulate low-disk-space incidents safely.



Test file-remediation operations in an isolated lab directory.



Maintain CSV audit logs.



Orchestrate incident response using PowerShell and Rundeck.



Architecture



1\. Disk-Space Monitoring — Check-DiskSpace.ps1



Checks available space on the C: drive.



Uses a 15 GB threshold.



Reports HEALTHY or LOW\_DISK\_SPACE.



Assigns severity levels.



Supports simulated low-space testing.



Records results in disk-space-log.csv.



2\. Remediation Lab — Invoke-DiskSpaceRemediation.ps1



Targets the dedicated Test-Lab directory.



Identifies files older than seven days.



Supports preview mode to inspect eligible files without deleting them.



Restricts intended remediation activity to lab test files.



Records file-processing activity in a CSV audit log.



3\. Incident Orchestration — Start-IncidentResponse.ps1



Runs the disk-space check.



Evaluates the result from the current check.



Determines the appropriate response.



Invokes lab remediation for simulated incidents.



Does not automatically run cleanup when a genuine low-disk-space condition is detected.



Records the overall decision in incident-response-log.csv.



4\. Workflow Automation — Rundeck



A local Rundeck job executes the PowerShell incident-response workflow and displays execution status and output.



Windows Task Scheduler is also configured to run the incident-response script daily.



Technology Stack



Windows 11



Windows PowerShell



Rundeck



Windows Task Scheduler



CSV audit logging



File-system operations



Incident-response automation



Validation and Test Results



Test scenario



Observed result



Real disk-space check



HEALTHY; 204.18 GB available in the latest recorded check



Simulated low-space check



LOW\_DISK\_SPACE, severity HIGH



End-to-end incident simulation



Incident detected and lab remediation invoked



Remediation preview



Eligible test file identified; no deletion during preview



Lab remediation test



One disposable test file deleted successfully in an earlier test



Latest healthy-state response



Disk space healthy; remediation Not required



Incident audit logging



Results recorded in CSV logs



Rundeck execution



Job completed successfully



Scheduled task



Task configured and previously reported successful execution



Test Notes



The low-disk-space condition was simulated. The actual C: drive remained healthy during testing. One disposable file in the dedicated Test-Lab directory was deleted during a remediation test. The latest healthy-state check did not invoke remediation.



These results demonstrate a local lab workflow; they do not establish production readiness or validate behavior during a genuine disk-space emergency.



Safety Controls



Remediation testing targets the project's dedicated Test-Lab directory.



Preview mode can be used to inspect eligible files before deletion.



Simulated incidents are used to test the response workflow.



Genuine low-disk-space results do not automatically trigger cleanup.



CSV logs record monitoring and response activity.



The lab should contain only disposable test files.



Project Structure



IT-Incident-Automation/

├── Check-DiskSpace.ps1

├── Invoke-DiskSpaceRemediation.ps1

├── Start-IncidentResponse.ps1

├── README.md

├── .gitignore

├── remediation-log-public.csv

├── Test-Lab/

└── Evidence/



Local execution logs are excluded from version control to avoid publishing machine-specific paths and raw execution data.



How to Run



Open PowerShell and navigate to the project directory.



Run a real disk-space check



.\\Start-IncidentResponse.ps1



Simulate a low-disk-space incident



.\\Start-IncidentResponse.ps1 -SimulateLowSpace



Warning: The simulation invokes the lab-remediation workflow. Only use disposable files in Test-Lab. Do not store personal, important, or production files in this directory.



Evidence



The Evidence/ directory contains screenshots documenting disk-space checks, simulated incident detection, remediation preview, lab remediation, audit logging, scheduled execution, and Rundeck execution.



Skills Demonstrated



PowerShell scripting and automation



Windows system administration



Disk-space monitoring and severity classification



Incident-response workflow design



Rundeck orchestration



Windows Task Scheduler



Controlled remediation testing



CSV audit logging



Technical documentation and troubleshooting



Future Improvements



Add notifications for high-severity incidents.



Improve remediation outcome reporting.



Make monitoring thresholds configurable.



Expand monitoring to other system-health indicators.



Add automated tests for error handling and edge cases.



Scope and Limitations



This is a local IT operations portfolio lab intended to demonstrate automation concepts. It is not a production-ready incident-response platform. Production deployment would require additional security controls, stronger validation, operational monitoring, and testing under failure conditions.

