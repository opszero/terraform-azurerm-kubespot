# Kubespot (Azure)

<img src="http://assets.opszero.com/images/auditkube.png" width="200px" />

Compliance Oriented Kubernetes Setup for AWS, Google Cloud and Microsoft Azure.

Kubespot is an open source terraform module that attempts to create a complete
compliance-oriented Kubernetes setup on AWS, Google Cloud and Azure. These add
additional security such as additional system logs, file system monitoring, hard
disk encryption and access control. Further, we setup the managed Redis and SQL
on each of the Cloud providers with limited access to the Kubernetes cluster so
things are further locked down. All of this should lead to setting up a HIPAA /
PCI / SOC2 being made straightforward and repeatable.

This covers how we setup your infrastructure on AWS, Google Cloud and Azure.
These are the three Cloud Providers that we currently support to run Kubernetes.
Further, we use the managed service provided by each of the Cloud Providers.
This document covers everything related to how infrastructure is setup within
each Cloud, how we create an isolated environment for Compliance and the
commonalities between them.

# Tools & Setup

```
brew install kubectl kubernetes-helm google-cloud-sdk terraform
```

# Keys

How to get key for cluster creation (client id and secret)

1. Sign in to Azure portal
2. Navigate to the Azure Active Directory
3. Select "App registrations"
4. If there is application already use existing one or create new one as follows
5. Click on the "New registration" button to create a new application registration
6. select the appropriate supported account type (e.g., "Accounts in this organizational directory only")
7. Click on the "Register" button to create the application.
8. After application is created, Under "Certificates & secrets," click on the "New client secret" button to create a new client secret.
9. Copy the client id and client secret and pass it to cluster creation opszero module

# Deployment

```sh
terraform init
terraform plan
terraform apply -auto-approve
```

# Teardown

```sh
terraform destroy -auto-approve
```
