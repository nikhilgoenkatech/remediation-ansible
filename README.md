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

Set up Ansible Tower with the `ansible-cloudformation.json` file on AWS infrastructure.

1. Login with your AWS account to the AWS console
1. Create an S3 bucket that will hold the files needed in this example. Name could be for example: `YOURNAME-workshop`
1. Copy your Ansible Tower license to your S3 bucket in AWS, naming **has to be**: `ansible-license.txt`
1. Copy your `playbook.yaml` to your S3 bucket, naming **has to be**: `playbook.yaml`
1. Navigate to CloudFormation
1. Choose template and "upload to S3"
1. Fill out the template: 

    ![cloudformation](./assets/cloudformation-template.png)
1. Create!

### Check your Ansible Tower installation

1. Check your outputs of the Cloudformation template:

    ![cloudformation output](./assets/cloudformation-outputs.png)

1. Navigate to your Ansible Tower instance
1. Login with the demo credentials: admin / dynatrace
1. Verify the setup:

    ![ansible projects](./assets/ansible-projects.png)
    ![ansible templates](./assets/ansible-templates.png)

    You should find something similar. (a project, a job template)



## Set up problem notification for Ansible Tower

Setup a problem notification in your Dynatrace tenant:

1. Setup notification

    ![dynatrace problem notification](./assets/dynatrace-problem-notification1.png)

2. Insert credentials and job template url (copy template url from the CloudFormation template outputs)

    ![dynatrace problem notification](./assets/dynatrace-problem-notification2.png)


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