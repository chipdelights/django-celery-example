# Django Celery Example on Kubernetes

Example used in the blog post [How to Use Celery and RabbitMQ with Django](https://simpleisbetterthancomplex.com/tutorial/2017/08/20/how-to-use-celery-with-django.html?utm_source=github&utm_medium=repository)

### Build and publish the docker images needed [ django & celery ]
```https://hub.docker.com/u/bseenu/```

### Create the kubernetes cluster using kops
#### Install kops, my environment is mac
```bash 
brew install kops
```
#### Create the S3 bucket to store the kops state
```bash
aws s3 mb <<bucketname>>
```
```bash
export KOPS_STATE_STORE=s3://<<bucketname>>
```
```bash
kops create cluster --zones us-east-1 --name <<cluster-name>> --yes
```
The above command will create kubernetes cluster with one master and two nodes [ Master: m3.medium, Nodes: t2.medium ]
and will generally take around 7-8 mins

#### Create an EFS Fileshare to be used as data volume
```bash
aws efs create-file-system --creation-token <<clusterfs-name>>
```
Make sure the efs is in the same vpc as the kubernetes cluster and whitelist the node security groups so that they 
can mount the efs file system

### Kubernetes deployment
####Set up the persistent volume claim
```bash
kubectl create -f k8s-templates/sqlite-configmap.yaml
kubectl create -f k8s-templates/sqlite-storage.yaml
kubectl create -f k8s-templates/sqlite-pv.yaml
kubectl create -f k8s-templates/sqlite-pvc.yaml
```
The above sets up the EFS filesystem as persistent volume which can be mounted by containers

####Django depployment
```bash
kubectl create -f k8s-templates/django-deployment.yaml 
```
The above sets up the django containers, you can verify by checking the command `kubectl get pods` you should be seeing them
in the running state
```bash
kubectl create -f k8s-templates/django-service.yaml
```
The above exposes the django deployment via ingress load balancer, you can get the ingress load balancer name by running 
the command `kubectl describe svc/django-service`, you should be able to point to the name on port 8000 and see the django
page

####Celery deployment
```bash
kubectl create -f k8s-templates/celery-deployment.yaml
```
The above sets up celery workers which refers to the same broker url as django and also uses the same data volume for writing
to sqlite3 as django app reads from
