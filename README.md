# Auto-remediation on TicketMonster

This repo builds upon the [monolith-to-microservices on OpenShift](https://github.com/dynatrace-innovationlab/monolith-to-microservice-openshift/) repository which uses TicketMonster as its sample application.


**Remediation**

The remediation scenario is as follows: Assuming we have a healthy build in production (tm-ui-v2, backend-v2, orders-service) we are switching the *feature flag* to route new traffic to the new orders-service. In our demo, the orders service will slow down the booking process. Rolling back the service won't solve the issue, instead we have to turn of the feature flag. This will be automatically done by the *remediaton action* link in the deployment description for enabling the feature flag. Please note that enabling the feature flag has to be done via a deployment to let Dyntrace know of this action.



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
1. Upload to files to your S3 bucket.
    - Your Ansible Tower license - naming **has to be**: `ansible-license.txt`
    - Your playbook - naming **has to be**: `playbook.yaml`
1. Set permission of both files to **public** (they will be automatically downloaded later)
1. Navigate to CloudFormation
1. Choose template and "upload to S3"
1. Fill out the template: 

    ![cloudformation](./assets/cloudformation-template.png)

1. Create! (and wait a couple of minutes for it to finish)

### Check your Ansible Tower installation

1. Check your outputs of the Cloudformation template:

    ![cloudformation output](./assets/cloudformation-outputs.png)

1. Navigate to your Ansible Tower instance
1. Login with the demo credentials: admin / dynatrace
1. Verify the setup:

    ![ansible projects](./assets/ansible-projects.png)
    ![ansible templates](./assets/ansible-templates.png)

    You should find something similar. (a project, a job template)

## Create inventory in Ansible Tower

```
---
tenantid: ton98156
apitoken: xE0Kw6nKR26IElCgRVPn6
commentuser: "Ansible Playbook"
dttag: "workshop-namespace:workshop1"
dtcommentapiurl: "https://{{tenantid}}.live.dynatrace.com/api/v1/problem/details/{{pid}}/comments?Api-Token={{apitoken}}"
dtdeploymentapiurl: "https://{{tenantid}}.live.dynatrace.com/api/v1/events/?Api-Token={{apitoken}}"
featuretoggleurl-internal-enable: ""
featuretoggleurl-internal-disable: ""
featuretoggleurl-microservice-enable: ""
featuretoggleurl-microservice-disable: ""
```


## Set up problem notification for Ansible Tower

Setup a problem notification in your Dynatrace tenant:

1. Setup notification

    ![dynatrace problem notification](./assets/dynatrace-problem-notification1.png)

1. Insert credentials and job template url (copy template url from the CloudFormation template outputs)

    ![dynatrace problem notification](./assets/dynatrace-problem-notification2.png)

1. Custom payload
    ```
    {
    "State":"{State}",
    "ProblemID":"{ProblemID}",
    "ProblemTitle":"{ProblemTitle}",
    "PID":"{PID}",
    "ImpactedEntity":"{ImpactedEntity},
    "ImpactedEntities":{ImpactedEntities}
    }
    ```

## Auto-remediation workflow


### Deploy load generator

### Activate / Deploy broken build


set environment variables:

oc set env dc/orders-service ORDER_SERVICE_ERROR_TYPE=slowdown 

### See auto-remediation in action

watch and see


## Troubleshooting

After the auto-remediation, set the trigger for the automatic deployment again.

```
$ oc set triggers dc/ticket-monster-ui-v2 --auto
```
