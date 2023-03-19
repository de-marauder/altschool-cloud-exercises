# Create project setup
# manifest_dir="~/kubeapps/socks-app/manifests"
# mkdir -p $manifest_dir
## cd $manifest_dir

# Download complete socks manifest
# NOTE: You'll probably have to configure the frontend service to be a LoadBalancer instead.
# Some pods are failing: 
# 1. cart-db (CrashLoopBackOff, not ready), 
# 2. catalogue (running but not ready), 
# 3. orders-db (CrashLoopBackOff, not ready), 
# 4. payment (running but not ready), 
# 6. queue-master (pending, not ready)
# 5. rabbitmq (1 ready, 1 not ready, CrashLoopBackOff),
# 6. shipping (pending, not ready)
# 8. user-db (CrashLoopBackOff) 

# curl -L https://github.com/microservices-demo/microservices-demo/blob/master/deploy/kubernetes/complete-demo.yaml?raw=true -o ${manifest_dir}/complete-demo.yaml
# kubectl apply -f ${manifest_dir}/complete-demo.yaml

