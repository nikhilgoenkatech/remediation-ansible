# Auto-remediation on TicketMonster

This repo builds upon the [monolith-to-microservices on OpenShift](https://github.com/dynatrace-innovationlab/monolith-to-microservice-openshift/) repository which uses TicketMonster as its sample application.


**Remediation**

The remediation scenario is as follows: Assuming we have a healthy build in production (tm-ui-v2, backend-v2, orders-service) we are switching the *feature flag* to route new traffic to the new orders-service. In our demo, the orders service will slow down the booking process. Rolling back the service won't solve the issue, instead we have to turn of the feature flag. This will be automatically done by the *remediaton action* link in the deployment description for enabling the feature flag. Please note that enabling the feature flag has to be done via a deployment to let Dyntrace know of this action.


## Prepare our services

1. Add auto-tagging rule to our services: on our tenant go to `Settings -> Tags -> Automatically applied tags`.
    
1. Add new rule for "Service" for services:

    Optional tag value:
    ```
    {ProcessGroup:KubernetesNamespace}-{ProcessGroup:KubernetesContainerName}-{Service:WebServiceName}
    ```
    where `Kubernetes namespace` exists.

1. Add a new alerting profile
    ![alerting profile](./assets/alerting-profile.png)

1. Adjust the anomaly detection settings for the service under suspicion. 
    ![anomaly detection](./assets/anomaly-detection.png)


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
    - Your remediation playbook - name **has to be**: `remediation.yaml`
1. Set permission of all files to **public** (they will be automatically downloaded later by the script)
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
tenantid: YOUR-TENTANT-ID
apitoken: YOUR-API-TOKEN
commentuser: "Ansible Playbook"
bookingservice_tag: "ws8-backend-v*-BookingService"
dtcommentapiurl: "https://{{tenantid}}.live.dynatrace.com/api/v1/problem/details/{{PID}}/comments?Api-Token={{apitoken}}"
dtdeploymentapiurl: "https://{{tenantid}}.live.dynatrace.com/api/v1/events/?Api-Token={{apitoken}}"
remediationaction: "https://tower-url/api/v2/job_templates/9/launch/"
featuretoggleurl_internal_enable: "http://backend-v2-PROJECT.YOURURL/ff4j-console?op=enable&uid=orders-internal"
featuretoggleurl_internal_disable: "http://backend-v2-PROJECT.YOURURL/ff4j-console?op=disable&uid=orders-internal"
featuretoggleurl_microservice_enable: "http://backend-v2-PROJECT.YOURURL/ff4j-console?op=enable&uid=orders-service"
featuretoggleurl_microservice_disable: "http://backend-v2-PROJECT.YOURURL/ff4j-console?op=disable&uid=orders-service"
```


## Set up problem notification for Ansible Tower

Setup a problem notification in your Dynatrace tenant:

1. Setup notification

    ![dynatrace problem notification](./assets/dynatrace-problem-notification1.png)

<!--
1. Insert credentials and job template url (copy template url from the CloudFormation template outputs)

    ![dynatrace problem notification](./assets/dynatrace-problem-notification2.png)
-->
1. Insert the API URL for the job template - *with* the trailing slash.
    ```
    https://YOUR-TOWER/api/v2/job_templates/YOUR-JOB-ID/launch/
 
    ```

1. Custom payload
    ```
    { "extra_vars": {
        "State":"{State}",
        "ProblemID":"{ProblemID}",
        "ProblemTitle":"{ProblemTitle}",
        "PID":"{PID}",
        "ImpactedEntity":"{ImpactedEntity}",
        "ImpactedEntities":{ImpactedEntities}
        }
    }
    ```

1.  Set the alerting profile to your own service/namespace.

## Auto-remediation workflow



### Deploy load generator


### See auto-remediation in action

watch and see

