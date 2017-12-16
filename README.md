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
```The above command will create kubernetes cluster with one master and two nodes [ Master: m3.medium, Nodes: t2.medium ]
and will generally take around 7-8 mins```
