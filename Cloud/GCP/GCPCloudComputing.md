js

# Links(youtube, Github and Mainlink)

Youtube : Andrew - https://www.youtube.com/watch?v=jpno8FSqpc8&t=3674s

https://app.exampro.co/

https://github.com/antonitz/google-cloud-associate-cloud-engineer

# Cloud computing

## What Is Cloud Computing?

**Cloud Computing**

The delivery of a shared pool of on-demand computing services over the public internet, that can be rapidly provisioned and released with minimal management effort or service provider interaction.

**The 5 Characteristics of Cloud**

1. On-demand Self Service - Provision resources automatically without requiring human interaction
2. Broad Network Access - Available over the network
3. Resource Pooling - Pooled resources to support a multi-tenant model allowing multiple customers to share the same applications or the same physical infrastructure
4. Rapid Elasticity - Rapidly provision and de-provision any of the cloud computing resources
5. Measured Service - Resource usage can be monitored, controlled and reported using metering capabilities

**Benefits of Cloud**

Agility - Flexibility for provisioning resources, Innovate faster

Cost - Pay as you go, Trade capital expenditure for variable expense

Speed - Resources on demand, Scriptable infrastructure

Global - Global data centres, Disaster recovery becomes easier, High availability

Security - Always up-to-date, Physical security, Encryption at rest and in transit, Compliance

## Characteristics

a. Ondemand self service - automatic creation(minimal efforts)

b. Broad NW access - avaialble on NW

c. Resource pooling  -  Multiple customers can / should share resources with a secuirty.

Ex : ppl living in an apartment but security will be there for their home

d. Rapic elasticity

e. Measured service  (monitoirng and alerting)

## Cloud deployment models

public (1 public cloud), private (on-prem cloud)), multi-cloud (2 or more public cloud),

hybrid cloud - (private cloud+public clud)

Hybrid cloud and Hybrid environments are both different.

## Cloud Service Models (XaaS)

IaaS: IaaS businesses offer services such as pay-as-you-go storage,
networking, and virtualization. IaaS gives users cloud-based
alternatives to on-premise infrastructure, so businesses can avoid
investing in expensive on-site resources.

PaaS: A PaaS vendor provides hardware and software tools over the
internet, and people use these tools to develop applications. PaaS users
tend to be developers.

SaaS: SaaS platforms make software available to users over the internet, usually for a monthly subscription fee.

On-premise: software that’s installed in the same building as your business.

![1730737187023](image/CloudComputing/1730737187023.png)

## Google Cloud Global Infrastructure

**Geography and Regions**

**Zone**

* A zone is a deployment area for Google Cloud resources within a region.
* The smallest entity in Google’s global network.
* A single failure domain within a region
* Deploy closer to users for optimal latency

**Region**

* Regions are independent geographic areas that are sub-divided into zones
* For fault tolerance and high availability
* Intercommunication <5ms between zones within a region

**Multi-Region**

* Multi-Regions are large geographic areas, that contain two or more regions
* Allows Google services to maximize redundancy and distribution within and across regions
* High availability (geo-redundant)

## Compute Service Options

IaaS - VM Instances

CaaS - GKE - Kubernetes Engine (Container as a service)

PaaS -  App engine

FaaS - Cloud functions, Function as a servie

FaaS - Serverless for Containers -- Cloud Run - Fully managed compute platform for containerized apps. Built ok Knative

**Compute Engine**

* Virtual Machines (VMs) called instances, Choose region and zone to
  deploy , You decide the operating system and the software you decide to
  put on it
* Use public or private images to create instances
* Pre-configured images and software packages available in Google Cloud Marketplace
* Manage multiple instances using instance groups
* Add/remove capacity using autoscaling with instance groups
* Attach/detach disks as needed
* Can be used with Google Cloud Storage
* Use SSH to connect directly
* Considered to be IaaS

**Google Kubernetes Engine (GKE)**

* Container-orchestration system for automating deploying, scaling, and managing containers
* Built on open-source Kubernetes
* Flexibility to integrate with on-premise Kubernetes
* Uses Compute Engine instances as nodes in a cluster.
* A cluster is a group of nodes or Compute Engine instances
* Considered Container as a Service (CaaS)

**App Engine**

* Fully managed, serverless platform for developing and hosting web applications at scale (PaaS)
* Provisions servers and scales your app instances based on demand
* Build your app in Go, Java, .NET, Node.js, PHP, Python, or Ruby
* Connect with other Google services seamlessly
* Integrates with Web Security Scanner to identify threats

**Cloud Functions**

* Serverless execution environment for building and connecting cloud services
* Simple, single-purpose functions that are attached to events
* Triggered when an event being watched is fired
* Your code executes in a fully managed environment
* No need to provision any infrastructure
* Cloud Functions can be written using JavaScript, Python 3, Go, or Java runtimes

**Cloud Run**

* Fully managed compute platform for deploying and scaling containerized applications quickly and securely
* Built upon an open standard Knative
* Abstracts away all infrastructure management
* Known as serverless for containers
* Any language, any library, any binary
* Considered Function as a service(FaaS)# Cloud fundamentalsStorage and Database Options

**Cloud Storage**

* Consistent, scalable, large-capacity, highly durable object storage
* 11 9’s Durability (99.999999999%)
* Unlimited storage with no minimum object size
* Use Cloud Storage for content delivery, data lakes, and backup
* Available in different storage classes and availability

**Storage Classes**

**Standard**

* Maximum availability and no limitations

**Nearline**

* Low-cost archival storage
* Accessed <1/month

**Coldline**

* Even lower-cost archival storage
* Accessed <1/quarter

**Archive**

* Lowest-cost archival storage
* Accessed <1/year

**Availability**

**Region**

* Single Region

**Dual-region**

* Pair of regions

**Multi-region**

* Large geographic area

**Filestore**

* Fully managed NFS file server
* NFSv3 compliant
* Store data from running applications
* Use with VM instances and Kubernetes clusters

**Persistent Disks**

* Durable block storage for instances
* Standard – Regular standard storage at a reasonable price
* Solid State (SSD) - Lower latency/higher IOPS

Both options are available in zonal and regional options

### Relational

#### Cloud SQL

* Fully managed database service
* PostgreSQL, MySQL, and SQL Server
* High availability across zones

#### Cloud Spanner

* Scalable relational database service
* Support transactions, strong consistency and synchronous replication
* High availability across regions and globally

#### Bare Metal Solution for Oracle (NEW)

* Lift and shift Oracle workloads to Google Cloud

### Key-value

No-SQL - Bigtable, Datastore, Firestore and Memorystore

#### Cloud Bigtable

* Fully managed, scalable NoSQL database
* High throughput with low latency
* Cluster resizing without downtime

#### BigQuery (NEW)

* Serverless, highly scalable, cost-effective multicloud data warehouse
* designed for business agility
* 99.99% availability

**Datastore**

* Fast, fully managed, serverless, NoSQL document database
* For mobile, web and IoT apps
* Multi-region replication and ACID transactions

### Document

#### Firestore

* NoSQL, realtime database
* Optimized for offline use
* Cluster resizing without downtime

#### Firebase Realtime Database (NEW)

* Store and sync data in real time

### In-memory

#### Memorystore

* Highly available in-memory service for Redis and Memcached
* Fully Managed

# Networking Services

**Virtual Private Cloud (VPC)**

* Virtualized network within Google Cloud
* Core networking service
* Global resource
* Each VPC contains a default network
* Additional networks can be created in your project, but networks cannot be shared between projects.

**Firewall Rules**

* Govern traffic coming into instances on a network
* The Default network has a default set of firewall rules
* Custom rules can be created

**Routes**

* Advanced networking functions for your instances
* Specifies how packets leaving an instance should be directed

**Load Balancing**

* Distributing Workloads across multiple instances

**HTTP(S) Load Balancing**

* Distribute traffic across regions to ensure that requests are routed to the closest region or, in the event of a failure or over-capacity, to a healthy instance in the next closest region.
* Distribute traffic based on the content type

**Network Load Balancing**

* Distribute traffic among server instances in the same region based on incoming IP protocol data, such as an address, port, and protocol

**Google Cloud DNS**

* Publish and maintain DNS records by using the same infrastructure that Google uses.
* Work with managed zones and DNS records through the CLI, API, or SDK

**Cloud VPN**

* Connect your existing network to your VPC through an IPsec connection.

**Direct Interconnect**

* Connect an existing network to your VPC using a highly available, low-latency, enterprise-grade connection.

**Direct Peering**

* Exchange internet traffic between your business network and Google at one of Google's broad-reaching edge network locations

**Carrier Peering**

* Connect your infrastructure to Google's network edge through highly available, lower-latency connections by using service providers

# Resource Hierarchy

![1730836760935](image/CloudComputing/1730836760935.png)

**Service-level resources**

* Compute Instance VM’s
* Cloud Storage buckets
* Cloud SQL databases

**Account-level resources**

* Organization
* Folders
* Projects

**Resource Hierarchy**

* Configure and grant access to the various resources
* Resource Hierarchy Structure
* Resources are organized hierarchically using a parent/child relationship
* Designed to map organizational structure to Google Cloud
* Better management of permissions and access control
* Policies controlled by IAM
* Access control policies and configuration settings on a parent resource are inherited by the child
* Each child object has exactly one parent.

**Domain (cloud level)**

**Organization (root node)**

**Folders**

* Grouping mechanism and isolation boundary

**Projects**

* Core organizational component

**Resources**

* Any service-level resource

**Labels**

* Categorize resources

# Controlling Costs and Budget Alerts

![1730949475316](image/CloudComputing/1730949475316.png)

**Committed Use Discounts (CUD’s)**

* Discounted prices when you commit to using a minimum level of resource for a specified term
* 1- or 3-year Commitment

**Commitment Types** - The commitment fee is billed monthly

**Spend-based commitment**

* Discount for a commitment to spend a minimum amount for a service (hours) in a particular region
* 25% discount for 1 year – 52% discount on a 3 year
* Available for Cloud SQL database instances and Google Cloud VMWare Engine
* Applies only to CPU and memory usage

**Resource-based commitment**

* Discount for commitment to spend a minimum amount for Compute Engine resource in a particular region.
* Available for vCPU, Memory, GPU and Local SSD
* 57% discount for most resources
* 70% for memory-optimized machine types
* For use across Projects

**Sustained-use discounts**

* Automatic discounts of running Compute Engine resources a significant portion of the billing month
* Applies to VCPUs and memory for most Compute Engine instance types
* Includes VM’s created by GKE
* Does not apply to App Engine flexible, Dataflow and E2 machine types

**GCP Pricing Calculator** – Quick estimate of what your usage will cost on Google Cloud

**Cloud Billing Budgets**

* Enables you to track your actual Google Cloud spend against your planned spend
* Budget alert threshold rules that are used to trigger email notifications to help you stay informed about your spending

# Cloud SDK and CLI

![1731100065274](image/CloudComputing/1731100065274.png)

**Cloud SDK**

Set of command line tools that allow you to manage resources through the terminal

* gcloud
* gsutil
* bq
* Kubectl

A user account is a Google account that allows end-users to authenticate directly to your application. For most common use cases on a single machine, using a user account is best practice.

A service account is a Google account associated with your GCP project and not a specific user. A service account can be used by providing a service account key to your application and is recommended to script Cloud SDK tools for use on multiple machines.

**Gcloud Init** - Authorizes access and performs other common Cloud SDK setup steps.

**gcloud auth login** - Authorize access for gcloud with Google user credentials

**Gcloud config** - Allows you to configure accounts and projects

**gcloud components** - Allow you to install, update and delete the components of the sdk

# IAM - Identity and access mgmt

## Cloud IAM

![1731192149148](image/CloudComputing/1731192149148.png)

![1731190735919](image/CloudComputing/1731190735919.png)

![1731190832999](image/CloudComputing/1731190832999.png)

**Identity and Access Management (IAM)**

You manage access control by defining who (identity) has what access (role) for which resource. This also includes organizations, folders, and projects.

A **policy** is a collection of bindings, audit configuration, and metadata.

A **binding** specifies how access should be granted on resources. It binds one or more members with a single role and any context-specific conditions that change how and when the role is granted.

The **metadata** includes additional information about the policy, such as an etag and version to facilitate policy management.

The **AuditConfig** field specifies the configuration data for how access attempts should be audited.

**Google Account** - Any email address that's associated with a Google Account, including gmail.com or other domains.

**Service Account** - An account for an application instead of an individual end user.

**Google Groups** - A named collection of Google Accounts and service accounts

**G Suite Domain** - Google Accounts that have been created in an organization's G Suite account

**Cloud Identity Domain** - Google Accounts in an organization that are not tied to any G Suite applications or features

**AllAuthenticatedUsers** - A special identifier that represents all service accounts and all users on the internet who have authenticated with a Google Account

**AllUsers** - A special identifier that represents anyone who is on the internet, including authenticated and unauthenticated users

**Roles**

* This is a named collection of permissions that grant access to perform actions on Google Cloud resources.
* You cannot grant a permission to the user directly
* You grant a role to a user and all the permissions that the role contains.

**Permissions**

* Determines what operations are allowed on a resource
* Correspond one-to-one with REST API methods
* Not granted to users directly
* E.g., compute.instances.list

**Primitive** - Roles historically available in the Google Cloud

* Owner
* Editor
* Viewer
* Avoid using these roles if possible

**Predefined** - Finer-grained access control than the primitive roles

**Custom** - Tailor permissions to the needs of your organization

**Conditions**

* Used to define and enforce conditional, attribute-based access control for Google Cloud resources.
* Conditions allow you to choose granting resource access to identities only if configured conditions are met
* When a condition exists, the access request is only granted if the condition expression = true

**Metadata**

* To help prevent a race condition when updating the policy, IAM supports concurrency control through the use of an etag field in the policy

**Audit Config**

* Determines which permission types are logged, and what identities, if any, are exempted from logging

## Policies and Conditions

![1731192425002](image/CloudComputing/1731192425002.png)

**Policy Limitations**

* 1 policy per resource (including organizations, folders, projects)
* 1500 members or 250 Google groups per policy
* Up to 7 minutes for policy changes to fully propagate across GCP
* Limit of 100 conditional role bindings per policy

Conditions - Condition attributes are either based on resource or based on details about the request (timestamp, originating/destination IP address)

**Condition Limitations**

* Limited to specific services
* Primitive roles are unsupported
* Members cannot be allUsers or allAuthenticatedUsers
* Limit of 100 conditional role bindings per policy
* 20 role bindings for same role and same member

**AuditConfig Logs**

Specifies the audit configuration for a service. The configuration determines which permission types are logged, and what identities, if any, are exempted from logging. An AuditConfig must have one or more AuditLogConfigs.

## Service Accounts

![1731327214936](image/GCPCloudComputing/1731327214936.png)

![1731327660296](image/GCPCloudComputing/1731327660296.png)

![1731327787030](image/GCPCloudComputing/1731327787030.png)

![1731328002595](image/GCPCloudComputing/1731328002595.png)

![1731328071126](image/GCPCloudComputing/1731328071126.png)

A service account is a special kind of account used by an application or a virtual machine (VM) instance, not a person.

An application uses the service account to authenticate between the application and GCP services so that the users aren't directly involved

A special type of Google account intended to represent a non-human user that needs to authenticate and be authorized to access data in Google APIs.

**Service Account types**

* User-managed, User created, You choose the name
  service-account-name@project-id.iam.gserviceaccount.com

**Default**

* ~Using some GCP services create user-managed service accounts~
* ~Automatically granted the Editor role for the project~
* When using certain GCP services, default service accounts are automatically created. These are user-managed service accounts.
* These default service accounts are automatically granted the **Editor** role for the project
  project-id@appspot.gserviceaccount.com
  project-number-compute@developer.gservcieaccount.com

**Google-managed**

* Managed by Google, and they are used by Google services
* Some are visible, some hidden
* Name ends with "Service Agent" or "Service Account”

**Service Account Keys**

**Key Management** – None, All handled by Google

**User managed**

**Key Management** - Key storage, Key distribution, Key revocation, Key rotation, Protecting the keys from unauthorized users, Key recovery

**Access scopes**

* Service Account scopes are the legacy method of specifying permissions for your instance
* And they are used in substitution of IAM roles
* These are used specifically for default
* Or automatically created service accounts
* Based on enabled API's

## Cloud Identity

![1731343652938](image/GCPCloudComputing/1731343652938.png)

**loud Identity** is an Identity as a Service (IDaaS) solution that centrally manages users and groups. This would be the sole system for authentication and that provides a single sign-on experience for all employees of an organization to be used for all your internal and external applications.

**Device management** - lets people in any organization access their work accounts from mobile devices while keeping the organization's data more secure.

**Security** - Helps by applying security best practices along with being able to deploy 2SV for the whole company along with enforcement controls and can also manage passwords to make sure they are meeting the enforced password requirements automatically.

**Single Sign-on** - With single sign-on (SSO), users can access many applications without having to enter their username and password for each application

**Reporting** - This covers audit logs for logins, groups, devices and even tokens. You are even able to export these logs to BigQuery for analysis. You can then create reports from these logs that cover security, applications and activity.

**Directory Management** - Provides profile information for users in your organization, email and group addresses, and shared external contacts in the Directory. Using Google Cloud Directory Sync (GCDS), you can synchronize the data in your Google Account with your Microsoft Active Directory or LDAP server. GCDS doesn't migrate any content (such as email messages, calendar events, or files) to your Google Account. You use GCDS to synchronize all your users, groups, and shared contacts to match the information in your LDAP server.

**Google Cloud Directory Sync** is a free Google-provided tool that implements the synchronization process and can be run either on Google Cloud or in your on-premises environment. Synchronization is one-way so that Active Directory remains the source of truth.

## Cloud IAM Best Practices

![1731344796546](image/GCPCloudComputing/1731344796546.png)

![1731345021497](image/GCPCloudComputing/1731345021497.png)

![1731346849961](image/GCPCloudComputing/1731346849961.png)

![1731346923206](image/GCPCloudComputing/1731346923206.png)

**Policy Management**

* To grant access to all projects in your Organization, use an organization-level policy
* Grant roles to a Google group instead of individual users where possible
* When granting multiple roles to a particular task, create a Google group instead

# Networking services

## Networking Refresher PART 1

**Correction** : ~3:30 Timestamp. IPv6 (Internet Protocol version 6) was **not** designed in 2017. It was actually developed in the mid-1990s to address IPv4 address exhaustion. The initial specification of IPv6 was published in 1998 as RFC 2460.

![1731355351734](image/GCPCloudComputing/1731355351734.png)

![1731355672202](image/GCPCloudComputing/1731355672202.png)

![1731355784582](image/GCPCloudComputing/1731355784582.png)

![1731355948924](image/GCPCloudComputing/1731355948924.png)

![1731355985418](image/GCPCloudComputing/1731355985418.png)

![1731356032898](image/GCPCloudComputing/1731356032898.png)

![1731356050666](image/GCPCloudComputing/1731356050666.png)

![1731356122254](image/GCPCloudComputing/1731356122254.png)

![1731356497308](image/GCPCloudComputing/1731356497308.png)

![1731356680564](image/GCPCloudComputing/1731356680564.png)

![1731356812725](image/GCPCloudComputing/1731356812725.png)

![1731356883600](image/GCPCloudComputing/1731356883600.png)

![1731357005784](image/GCPCloudComputing/1731357005784.png)

## VPC-Virtual Private Cloud

![1731361066494](image/GCPCloudComputing/1731361066494.png)

![1731361271403](image/GCPCloudComputing/1731361271403.png)

![1731361357460](image/GCPCloudComputing/1731361357460.png)

![1731361386578](image/GCPCloudComputing/1731361386578.png)

## VPC NW Subnets

![1731378335944](image/GCPCloudComputing/1731378335944.png)

![1731378488146](image/GCPCloudComputing/1731378488146.png)

prefix length must be smaller in number.

auto mode starts with /20 can me made in /16 at custom.

auto mode can be convert to custom but not vice versa

![1731378712273](image/GCPCloudComputing/1731378712273.png)

## Routing and Private google access

![1731378907884](image/GCPCloudComputing/1731378907884.png)

![1731378935231](image/GCPCloudComputing/1731378935231.png)![1731378951287](image/GCPCloudComputing/1731378951287.png)

![1731379040330](image/GCPCloudComputing/1731379040330.png)

![1731416735001](image/GCPCloudComputing/1731416735001.png)![1731418178348](image/GCPCloudComputing/1731418178348.png)'

![1731418214268](image/GCPCloudComputing/1731418214268.png)

![1731418882362](image/GCPCloudComputing/1731418882362.png)

![1731419086151](image/GCPCloudComputing/1731419086151.png)

![1731419393346](image/GCPCloudComputing/1731419393346.png)

## IP Addressing

![1731425339970](image/GCPCloudComputing/1731425339970.png)

![1731425358857](image/GCPCloudComputing/1731425358857.png)

![1731426904530](image/GCPCloudComputing/1731426904530.png)

![1731436064891](image/GCPCloudComputing/1731436064891.png)

![1731436110047](image/GCPCloudComputing/1731436110047.png)

![1731436134661](image/GCPCloudComputing/1731436134661.png)

![1731436518531](image/GCPCloudComputing/1731436518531.png)

![1731436540905](image/GCPCloudComputing/1731436540905.png)

![1731436765379](image/GCPCloudComputing/1731436765379.png)

![1731437226981](image/GCPCloudComputing/1731437226981.png)

![1731437266764](image/GCPCloudComputing/1731437266764.png)

## Firewalls and Firewall rules

![1731494131699](image/GCPCloudComputing/1731494131699.png)

![1731494317525](image/GCPCloudComputing/1731494317525.png)

![1731494493144](image/GCPCloudComputing/1731494493144.png)

![1731494772097](image/GCPCloudComputing/1731494772097.png)

## VPC Netpeering

![1731518712079](image/GCPCloudComputing/1731518712079.png)

![1731521005991](image/GCPCloudComputing/1731521005991.png)

![1731522805176](image/GCPCloudComputing/1731522805176.png)

## Shared VPC

![1731526202295](image/GCPCloudComputing/1731526202295.png)

![1731526250123](image/GCPCloudComputing/1731526250123.png)

![1731526315220](image/GCPCloudComputing/1731526315220.png)

![1731526332471](image/GCPCloudComputing/1731526332471.png)

## VPC Flow logs

![1731526713956](image/GCPCloudComputing/1731526713956.png)

![1731526904570](image/GCPCloudComputing/1731526904570.png)

![1731526969707](image/GCPCloudComputing/1731526969707.png)

![1731527044586](image/GCPCloudComputing/1731527044586.png)

## DNS Fundamentals

![1731527464544](image/GCPCloudComputing/1731527464544.png)

![1731527622770](image/GCPCloudComputing/1731527622770.png)

![1731527666460](image/GCPCloudComputing/1731527666460.png)

![1731528017177](image/GCPCloudComputing/1731528017177.png)

![1731528328212](image/GCPCloudComputing/1731528328212.png)

## DNS Record type

![1731530259835](image/GCPCloudComputing/1731530259835.png)

![1731530354927](image/GCPCloudComputing/1731530354927.png)

![1731532186937](image/GCPCloudComputing/1731532186937.png)

![1731532271059](image/GCPCloudComputing/1731532271059.png)

![1731532291823](image/GCPCloudComputing/1731532291823.png)

![1731532441106](image/GCPCloudComputing/1731532441106.png)

![1731532493744](image/GCPCloudComputing/1731532493744.png)

![1731532587022](image/GCPCloudComputing/1731532587022.png)

## NAT1-Network address transalation

![1731592456916](image/GCPCloudComputing/1731592456916.png)

![1731592585222](image/GCPCloudComputing/1731592585222.png)

![1731592744123](image/GCPCloudComputing/1731592744123.png)

![1731592798741](image/GCPCloudComputing/1731592798741.png)

![1731593176933](image/GCPCloudComputing/1731593176933.png)

![1731593205887](image/GCPCloudComputing/1731593205887.png)

![1731593989075](image/GCPCloudComputing/1731593989075.png)

![1731594187218](image/GCPCloudComputing/1731594187218.png)

## Cloud DNS

![1731599338177](image/GCPCloudComputing/1731599338177.png)

![1731599407760](image/GCPCloudComputing/1731599407760.png)

# Compute engine

## Virtualizaton fundamentals

![1731601979103](image/GCPCloudComputing/1731601979103.png)

![1731601995148](image/GCPCloudComputing/1731601995148.png)

![1731602041698](image/GCPCloudComputing/1731602041698.png)

![1731602118980](image/GCPCloudComputing/1731602118980.png)

![1731602318124](image/GCPCloudComputing/1731602318124.png)

![1731602905420](image/GCPCloudComputing/1731602905420.png)

![1731603826079](image/GCPCloudComputing/1731603826079.png)

## Compute engine overview

![1731604054713](image/GCPCloudComputing/1731604054713.png)

![1731604068450](image/GCPCloudComputing/1731604068450.png)

![1731604180002](image/GCPCloudComputing/1731604180002.png)

![1731604326987](image/GCPCloudComputing/1731604326987.png)

![1731604482234](image/GCPCloudComputing/1731604482234.png)

![1731604568403](image/GCPCloudComputing/1731604568403.png)

## Compute engine - machine types

![1731613421651](image/GCPCloudComputing/1731613421651.png)

![1731613535323](image/GCPCloudComputing/1731613535323.png)

![1731613592003](image/GCPCloudComputing/1731613592003.png)

![1731613665393](image/GCPCloudComputing/1731613665393.png)

![1731613682471](image/GCPCloudComputing/1731613682471.png)

![1731613700280](image/GCPCloudComputing/1731613700280.png)

![1731613738202](image/GCPCloudComputing/1731613738202.png)

![1731613788814](image/GCPCloudComputing/1731613788814.png)

![1731613836916](image/GCPCloudComputing/1731613836916.png)

![1731613854885](image/GCPCloudComputing/1731613854885.png)

![1731613906408](image/GCPCloudComputing/1731613906408.png)

![1731613924205](image/GCPCloudComputing/1731613924205.png)

![1731613988642](image/GCPCloudComputing/1731613988642.png)

![1731614043544](image/GCPCloudComputing/1731614043544.png)

![1731614103959](image/GCPCloudComputing/1731614103959.png)

![1731614123926](image/GCPCloudComputing/1731614123926.png)

![1731614172171](image/GCPCloudComputing/1731614172171.png)

![1731614199064](image/GCPCloudComputing/1731614199064.png)

## Managing instances

Using the `gcloud compute instances move` command to move an instance to another zone is no longer possible, and attempting to do so will result in a 400 error. This functionality has been deprecated, and Google Cloud now recommends alternative methods such as creating snapshots of the instance and then using those snapshots to create a new instance in the desired zone.

Resource:

* [Create custom images | Compute Engine Documentation](https://cloud.google.com/compute/docs/images/create-custom)
* [Move a VM instance between zones or regions](https://cloud.google.com/compute/docs/instances/moving-instance-across-zones)

![1731618958085](image/GCPCloudComputing/1731618958085.png)

![1731619018514](image/GCPCloudComputing/1731619018514.png)

![1731619031879](image/GCPCloudComputing/1731619031879.png)

![1731619065358](image/GCPCloudComputing/1731619065358.png)

![1731619164819](image/GCPCloudComputing/1731619164819.png)

![1731619690751](image/GCPCloudComputing/1731619690751.png)

![1731619823721](image/GCPCloudComputing/1731619823721.png)

![1731619883002](image/GCPCloudComputing/1731619883002.png)

![1731620077363](image/GCPCloudComputing/1731620077363.png)

![1731620151909](image/GCPCloudComputing/1731620151909.png)

![1731620170302](image/GCPCloudComputing/1731620170302.png)

## Compute engine billing

## Compute Engine Billing


| Maximum of 20% monthly SUDs                                          | Maximum of 30% monthly SUDs                                                 |
| ---------------------------------------------------------------------- | ----------------------------------------------------------------------------- |
| - All general-purpose N2 and N2D predefined and custom machine types | - All general-purpose N1 predefined and custom machine types                |
| - All general-purpose N2 and N2D sole-tenant node types              | - All general-purpose N1 sole-tenant node types                             |
| - All compute-optimized C2 machine types                             | - All memory-optimized M1 and M2 machine types                              |
| - All compute-optimized C2 sole-tenant node types                    | - All memory-optimized M1 and M2 sole-tenant node types                     |
|                                                                      | -`f1-micro` and `g1-small` shared-core machine types                        |
|                                                                      | - All GPU devices with the exception of NVIDIA H100, A100, and L4 GPU types |

## Sustained use discounts for up to 20%

Resources: All N2 and N2D predefined and custom machine types, All N2 and N2D sole-tenant node types, All C2 machine types, All C2 sole-tenant node types


| Usage level (% of the month) | % at which incremental is charged | Incremental rate (USD/hour) example:`c2-standard-4` VM |
| ------------------------------ | ----------------------------------- | -------------------------------------------------------- |
| 0%–25%                      | 100% of base rate                 | $0.2088                                                |
| 25%–50%                     | 86.78% of base rate               | $0.1811                                                |
| 50%–75%                     | 73.3% of base rate                | $0.1530                                                |
| 75%–100%                    | 60% of base rate                  | $0.1252                                                |

## Sustained use discounts for up to 30%

Resources: All M1 and M2 machine types, All M1 and M2 sole-tenant node types, f1-micro and g1-small shared-core machine types, All GPU devices with the exception of NVIDIA H100, A100, and L4 GPU types


| Usage level (% of month) | % at which incremental is charged | Incremental rate (USD/hour) example:`n1-standard-1` VM |
| -------------------------- | ----------------------------------- | -------------------------------------------------------- |
| 0%–25%                  | 100% of base rate                 | $0.0475                                                |
| 25%–50%                 | 80% of base rate                  | $0.0380                                                |
| 50%–75%                 | 60% of base rate                  | $0.0285                                                |
| 75%–100%                | 40% of base rate                  | $0.0190                                                |

![1731778991782](image/GCPCloudComputing/1731778991782.png)

![1731779143016](image/GCPCloudComputing/1731779143016.png)

![1731779493377](image/GCPCloudComputing/1731779493377.png)

![1731779577596](image/GCPCloudComputing/1731779577596.png)

![1731779701207](image/GCPCloudComputing/1731779701207.png)

![1731779955344](image/GCPCloudComputing/1731779955344.png)

![1731780110182](image/GCPCloudComputing/1731780110182.png)

## Storage fundamentals

![1731780602464](image/GCPCloudComputing/1731780602464.png)

![1731780720416](image/GCPCloudComputing/1731780720416.png)

![1731780837760](image/GCPCloudComputing/1731780837760.png)

![1731781181554](image/GCPCloudComputing/1731781181554.png)

![1731781543889](image/GCPCloudComputing/1731781543889.png)

## Persistant disks and local SSD

![1731781997876](image/GCPCloudComputing/1731781997876.png)

![1731782238021](image/GCPCloudComputing/1731782238021.png)

![1731782792417](image/GCPCloudComputing/1731782792417.png)

![1731782856695](image/GCPCloudComputing/1731782856695.png)

![1731783012214](image/GCPCloudComputing/1731783012214.png)

![1731783061626](image/GCPCloudComputing/1731783061626.png)

![1731783135128](image/GCPCloudComputing/1731783135128.png)

![1731783156493](image/GCPCloudComputing/1731783156493.png)

![1731783200899](image/GCPCloudComputing/1731783200899.png)

![1731783226998](image/GCPCloudComputing/1731783226998.png)

![1731783239179](image/GCPCloudComputing/1731783239179.png)

![1731783761951](image/GCPCloudComputing/1731783761951.png)

![1731783784022](image/GCPCloudComputing/1731783784022.png)

1 vcpu for 2000 io ops

![1731783881190](image/GCPCloudComputing/1731783881190.png)

## Managing disks on compute engine-lab

## Snapshots

![1731803593940](image/GCPCloudComputing/1731803593940.png)

![1731803749657](image/GCPCloudComputing/1731803749657.png)

![1731803832571](image/GCPCloudComputing/1731803832571.png)

![1731803961618](image/GCPCloudComputing/1731803961618.png)

![1731803983970](image/GCPCloudComputing/1731803983970.png)

![1731804161479](image/GCPCloudComputing/1731804161479.png)

## Deployment manager

![1731869905070](image/GCPCloudComputing/1731869905070.png)

![1731869601464](image/GCPCloudComputing/1731869601464.png)

![1731869586322](image/GCPCloudComputing/1731869586322.png)

![1731869648986](image/GCPCloudComputing/1731869648986.png)

![1731870049353](image/GCPCloudComputing/1731870049353.png)

![1731870102701](image/GCPCloudComputing/1731870102701.png)

![1731870367777](image/GCPCloudComputing/1731870367777.png)

# High availability and auto scaling

## cloud load balancer

![1731959422916](image/GCPCloudComputing/1731959422916.png)

![1731960085050](image/GCPCloudComputing/1731960085050.png)

![1731960286722](image/GCPCloudComputing/1731960286722.png)

## GCP Load Balancer Study Notes

### Backend Services

**Defines how Cloud Load Balancing distributes traffic**

* **Health Checks**: Verifies the health of backend instances.
* **Session Affinity**: Ensures traffic from a client is sent to the same backend.
* **Service Timeout**: Specifies the time the load balancer waits for a response from the backend.
* **Traffic Distribution**: Balances traffic across multiple backends.
* **Backends**: Instances or endpoints receiving the traffic.

### HTTP(S) Traffic Management

* **Cross-region load balancing** : Distributes traffic across multiple regions for high availability.
* **Content-based load balancing** : Routes traffic based on URL path to different backend services.

### HTTP(S) Load Balancer

**Global, proxy-based Layer 7 load balancer**

* **Features** :
* **Layer 7 Load Balancer**
* **Single Unicast IP address**
* **Implemented on Google Front Ends (GFE)**
* **Global, external, internal**
* **HTTPS and SSL for encryption in transit**
* **IPv4/IPv6 traffic**
* **Distribute traffic by location or content**
* **SSL certificates must be used for HTTPS**
* **Ports 80, 8080; 443 (HTTPS)**

### SSL Proxy

**Reverse proxy load balancer that distributes SSL traffic coming from the internet to VMs**

* **Features** :
* **Layer 4 Load Balancer**
* **Global and external**
* **Support for TCP with SSL offload**
* **Distribute traffic by location only**
* **IPv4/IPv6 traffic**
* **Used for protocols that use SSL**

### TCP Proxy

**Reverse proxy load balancer that distributes TCP traffic coming from the internet to VMs**

* **Features** :
* **Layer 4 Load Balancer**
* **Global and external**
* **Forward traffic as SSL or TCP**
* **Distribute traffic by location only**
* **IPv4/IPv6 traffic**
* **Supports many well-known TCP ports**

### Network Load Balancer

**Pass-through load balancer that distributes TCP and UDP traffic to VMs**

* **Features** :
* **Regional and external**
* **Supports either TCP or UDP, not both**
* **Traffic distributed by protocol, scheme, and scope**
* **No TLS offloading or proxying**
* **Self-managed SSL certificates**

### Internal Load Balancer

**Pass-through load balancer that distributes TCP and UDP traffic to VMs within a VPC**

* **Features** :
* **Layer 4 Load Balancer**
* **Regional and internal**
* **Supports either TCP or UDP, not both**
* **Balances internal traffic between instances**
* **Traffic sent to backend directly**
* **Does not terminate client connections**
* **Forwarding rules: specify at least one and up to five ports by number**

### Load Balancer Types

* **HTTP(S)**
* **SSL Proxy**
* **TCP Proxy**
* **Network**
* **Internal**

![1731960570012](image/GCPCloudComputing/1731960570012.png)

![1731960770524](image/GCPCloudComputing/1731960770524.png)

![1731960917083](image/GCPCloudComputing/1731960917083.png)

![1731961021370](image/GCPCloudComputing/1731961021370.png)

![1731961113794](image/GCPCloudComputing/1731961113794.png)

![1731961187338](image/GCPCloudComputing/1731961187338.png)

![1731961203017](image/GCPCloudComputing/1731961203017.png)

## Instance group and templates

![1731961363546](image/GCPCloudComputing/1731961363546.png)

![1731961374314](image/GCPCloudComputing/1731961374314.png)

![1731961519031](image/GCPCloudComputing/1731961519031.png)

![1731961554144](image/GCPCloudComputing/1731961554144.png)

![1731961632708](image/GCPCloudComputing/1731961632708.png)

![1731961673743](image/GCPCloudComputing/1731961673743.png)

![1731961718239](image/GCPCloudComputing/1731961718239.png)

![1731961786287](image/GCPCloudComputing/1731961786287.png)

![1731961813961](image/GCPCloudComputing/1731961813961.png)

![1731961996252](image/GCPCloudComputing/1731961996252.png)

# Kubernetes

## Intro about containers

![1731965559668](image/GCPCloudComputing/1731965559668.png)

![1731965655977](image/GCPCloudComputing/1731965655977.png)

![1731965788750](image/GCPCloudComputing/1731965788750.png)

![1731965913110](image/GCPCloudComputing/1731965913110.png)

![1731965992801](image/GCPCloudComputing/1731965992801.png)

![1731966066762](image/GCPCloudComputing/1731966066762.png)

## Concepts

concepts

![1731986884677](image/GCPCloudComputing/1731986884677.png)

![1731986992561](image/GCPCloudComputing/1731986992561.png)

![1731987105181](image/GCPCloudComputing/1731987105181.png)

![1731987188831](image/GCPCloudComputing/1731987188831.png)

![1731987208301](image/GCPCloudComputing/1731987208301.png)

![1731987231162](image/GCPCloudComputing/1731987231162.png)

![1731987256858](image/GCPCloudComputing/1731987256858.png)

![1731987285943](image/GCPCloudComputing/1731987285943.png)

![1731987340564](image/GCPCloudComputing/1731987340564.png)

![1731987382131](image/GCPCloudComputing/1731987382131.png)

![1731987397563](image/GCPCloudComputing/1731987397563.png)

## Cluster and node mgmt

![1731987806421](image/GCPCloudComputing/1731987806421.png)

![1731988158063](image/GCPCloudComputing/1731988158063.png)

![1731988310303](image/GCPCloudComputing/1731988310303.png)

![1731988492104](image/GCPCloudComputing/1731988492104.png)

![1731988541392](image/GCPCloudComputing/1731988541392.png)

![1731988626985](image/GCPCloudComputing/1731988626985.png)

![1731989080429](image/GCPCloudComputing/1731989080429.png)

## Pods and object management

![1731989260131](image/GCPCloudComputing/1731989260131.png)

![1731989275282](image/GCPCloudComputing/1731989275282.png)

![1731989381379](image/GCPCloudComputing/1731989381379.png)

![1731989421826](image/GCPCloudComputing/1731989421826.png)

![1731989446452](image/GCPCloudComputing/1731989446452.png)

![1731989497913](image/GCPCloudComputing/1731989497913.png)

![1731989550758](image/GCPCloudComputing/1731989550758.png)

![1731989609235](image/GCPCloudComputing/1731989609235.png)

![1731989626056](image/GCPCloudComputing/1731989626056.png)

![1731989741327](image/GCPCloudComputing/1731989741327.png)

![1731989837157](image/GCPCloudComputing/1731989837157.png)

![1731989960230](image/GCPCloudComputing/1731989960230.png)

## Services

![1731990476979](image/GCPCloudComputing/1731990476979.png)

![1731990571911](image/GCPCloudComputing/1731990571911.png)

![1731990595342](image/GCPCloudComputing/1731990595342.png)

![1731990671834](image/GCPCloudComputing/1731990671834.png)

![1731990748018](image/GCPCloudComputing/1731990748018.png)

![1731990766222](image/GCPCloudComputing/1731990766222.png)

![1731990887157](image/GCPCloudComputing/1731990887157.png)

![1731990936827](image/GCPCloudComputing/1731990936827.png)

![1731991158069](image/GCPCloudComputing/1731991158069.png)

![1731991209256](image/GCPCloudComputing/1731991209256.png)

![1731991581186](image/GCPCloudComputing/1731991581186.png)

![1731991610747](image/GCPCloudComputing/1731991610747.png)

![1731991763624](image/GCPCloudComputing/1731991763624.png)

![1731991844737](image/GCPCloudComputing/1731991844737.png)

![1731991940613](image/GCPCloudComputing/1731991940613.png)

![1731991960196](image/GCPCloudComputing/1731991960196.png)

![1731992076012](image/GCPCloudComputing/1731992076012.png)

![1731992091022](image/GCPCloudComputing/1731992091022.png)

![1731992148256](image/GCPCloudComputing/1731992148256.png)

## Ingress for GKE

![1732035711795](image/GCPCloudComputing/1732035711795.png)

![1732035762235](image/GCPCloudComputing/1732035762235.png)

![1732035863857](image/GCPCloudComputing/1732035863857.png)

![1732035942556](image/GCPCloudComputing/1732035942556.png)

![1732036037947](image/GCPCloudComputing/1732036037947.png)

## GKE Storage options

![1732036297459](image/GCPCloudComputing/1732036297459.png)

![1732036557906](image/GCPCloudComputing/1732036557906.png)

![1732036950036](image/GCPCloudComputing/1732036950036.png)

![1732037099999](image/GCPCloudComputing/1732037099999.png)

![1732037451330](image/GCPCloudComputing/1732037451330.png)

![1732037563207](image/GCPCloudComputing/1732037563207.png)

![1732037637830](image/GCPCloudComputing/1732037637830.png)

![1732037747293](image/GCPCloudComputing/1732037747293.png)

![1732037929751](image/GCPCloudComputing/1732037929751.png)

# JSSudha

## jssudha
