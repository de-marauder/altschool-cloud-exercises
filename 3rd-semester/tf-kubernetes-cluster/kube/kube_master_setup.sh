#!/bin/bash
set -o errexit
sudo su
# =========================================================================
# First, set the following environment variables. Replace 10.0.0.10 with the IP of your master node.

# Set the private IP of the node as IPADDR
IPADDR="$(ip --json a s | jq -r '.[] | if .ifname == "eth0" then .addr_info[] | if .family == "inet" then .local else empty end else empty end')"
NODENAME=$(hostname -s)
POD_CIDR="192.168.0.0/16"
# =========================================================================

# =========================================================================
# Now, initialize the master node control plane configurations using the following kubeadm command.
# If your machine specs are above 2GB memory and 1vCPU, you can remove "Mem" and "NumCPU" from --ignore-preflight-errors

kubeadm init --apiserver-advertise-address=$IPADDR  --apiserver-cert-extra-sans=$IPADDR  --pod-network-cidr=$POD_CIDR --node-name $NODENAME --ignore-preflight-errors Swap,Mem,NumCPU
# kubeadm token create --print-join-command
# =========================================================================
# =========================================================================

export KUBECONFIG=/etc/kubernetes/admin.conf
echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >>~/.bashrc

# deploy a pod network to the cluster
# kubectl apply -f [podnetwork].yaml

# Label worker nodes
# kubectl label node $NODE_HOSTNAME  node-role.kubernetes.io/worker=worker

# Install Metrics server
# kubectl apply -f https://raw.githubusercontent.com/techiescamp/kubeadm-scripts/main/manifests/metrics-server.yaml

# Access node metrics
# kubectl top nodes

# You can also view the pod CPU and memory metrics using the following command.
# kubectl top pod -n kube-system


###################################
# Deploy A Sample Nginx Application
###################################

######################################################################
# Create an Nginx deployment. Execute the following directly on the command line. It deploys the pod in the default namespace.

# cat <<EOF | kubectl apply -f -
# apiVersion: apps/v1
# kind: Deployment
# metadata:
#   name: nginx-deployment
# spec:
#   selector:
#     matchLabels:
#       app: nginx
#   replicas: 2 
#   template:
#     metadata:
#       labels:
#         app: nginx
#     spec:
#       containers:
#       - name: nginx
#         image: nginx:latest
#         ports:
#         - containerPort: 80      
# EOF
######################################################################


######################################################################
# Expose the Nginx deployment on a NodePort 32000

# cat <<EOF | kubectl apply -f -
# apiVersion: v1
# kind: Service
# metadata:
#   name: nginx-service
# spec:
#   selector: 
#     app: nginx
#   type: NodePort  
#   ports:
#     - port: 80
#       targetPort: 80
#       nodePort: 32000
# EOF
######################################################################


#####################################################################################
## Install Helm
#####################################################################################

# curl -LO https://get.helm.sh/helm-v3.11.1-linux-amd64.tar.gz
# tar -zxvf helm-v3.11.1-linux-amd64.tar.gz
# mv linux-amd64/helm /usr/local/bin/helm
# unset http_proxy
# unset https_proxy

#####################################################################################
## Cert manager installation using helm
#####################################################################################

# helm repo add jetstack https://charts.jetstack.io
# helm repo update
# helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --version v1.11.0 --set installCRDs=true --set webhook.timeoutSeconds=30

#####################################################################################

#####################################################################################
## Install nginx ingress controller with helm ##
#####################################################################################

# helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx 
# helm repo update
# helm install ingress-nginx ingress-nginx/ingress-nginx --namespace ingress-nginx --create-namespace
# helm --upgrade install ingress-nginx ingress-nginx/ingress-nginx --namespace ingress-nginx --create-namespace --set controller.service.type=NodePort
#####################################################################################

#####################################################################################

#####################################################################################
# ClusterIssuer configuration
#####################################################################################
# cat <<EOF > clusterissuer.yaml
# apiVersion: cert-manager.io/v1
# kind: ClusterIssuer
# metadata:
#   name: letsencrypt-cluster-issuer
# spec:
#   acme:
#     server: https://acme-v02.api.letsencrypt.org/directory
#     email: chiezike16@gmail.com
#     privateKeySecretRef:
#       name: letsencrypt-cluster-issuer-key
#     solvers:
#     - http01:
#        ingress:
#          class: nginx
# EOF

# kubectl apply -f clusterissuer.yaml

# kubectl describe clusterissuer letsencrypt-cluster-issuer

## Apply deployment and services for web application
# kubectl apply -f ./path/to/svc ./path/to/deployment

#####################################################################################

#####################################################################################
## Install prometheus using helm
#####################################################################################

# helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
# helm search repo prometheus-community

## Install prom, grafana, alertmanager in one step for managing kubernetes
# helm install monitoring prometheus-community/kube-prometheus-stack --namespace monitoring --create-namespace

### OR 

## Install each component individually

# helm install prometheus prometheus-community/prometheus --namespace prometheus --create-namespace
# kubectl expose svc/prometheus-server --type=NodePort --namespace=prometheus --port=9090 --name=prometheus-service-ext # Make sure to use port 3000 

#####################################################################################

#####################################################################################
## Install grafana using helm
#####################################################################################

# helm repo add grafana https://grafana.github.io/helm-charts
# helm search repo grafana
# helm install grafana grafana/grafana --namespace grafana --create-namespace
# kubectl expose svc/grafana --type=NodePort --namespace=grafana --port 3000 --name=grafana-ext # Make sure to use port 3000

#####################################################################################
## Install Loki stack for log aggregation
#####################################################################################

# helm install loki grafana/loki-stack --version \
#   --namespace=monitoring \
#   --create-namespace \
#   -f "loki-values.yaml"

#####################################################################################
## Apply ingress
## Apply certificate
#####################################################################################

#####################################################################################
# Decode base64 secrets
# echo $BASE64_SECRET | base64 -d ; echo

#####################################################################################