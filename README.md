<h1>GitOps: A DevOps appproach for agile and efficient Cloud-Native environments</h1>
<h3>Final project submitted to obtain a bachelor's degree in Computer Science</h3>

![image](https://github.com/user-attachments/assets/69a89bcb-c74a-443a-b438-1a5b89927523)

<p>This project is used to demonstrate the benefits of using GitOps approach by deploying deploying a simple Django application running on a Kubernets cluster (AKS).
  The infrastrurcture is provisioned using Terraform as IaC tool and Github Actions as automation pipeline. After the infrastructure is ready, ArgoCD will be installed on the cluster by using Helm. 
  Then ArgoCD will start to manage the application's deployment by monitoring the manifests in this repository.
</p>
<p>
  Code changes submited to the src/ folder will trigger the CI pipeline that will build a new Docker image, publish it to Docker Hub and update the manifests.
</p>
