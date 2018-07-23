# Auto-remediation on TicketMonster

This repo builds upon the [monolith-to-microservices on OpenShift](https://github.com/dynatrace-innovationlab/monolith-to-microservice-openshift/) repository which uses TicketMonster as its sample application.


## Define remediaton actions as playbook

In ```playbook.yaml``` all remediation action should be defined. This will be the file that comprises all tasks that can be used for remediation.

## Execute remediation actions locally

Test the remediation actions locally with Ansible installed.
```
$ ansible-playbook playbook.yml
```

## Set up Ansible Tower as the automation platform



## Set up problem notification for Ansible Tower



## Auto-remediation workflow

### Deploy load generator

### Deploy healthy build

Deploy image and expose service

```
oc new-app jetzlstorfer/ticket-monster-ui-v2:healthy
oc expose svc/ticket-monster-ui-v2
```

### Deploy broken build

### See auto-remediation in action

## Troubleshooting
f
```
$ oc set triggers dc/ticket-monster-ui-v2 --auto
```