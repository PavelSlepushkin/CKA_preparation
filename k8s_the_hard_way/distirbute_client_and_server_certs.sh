# Figure out the 
# The Kubernetes API Server Certificate
# before pushing it to the hosts
# 10.8.8.11 -????


for instance in worker-1 worker-2 worker-3; do
  gcloud compute scp ca.pem ${instance}-key.pem ${instance}.pem ${instance}:~/
done
Copy the appropriate certificates and private keys to each controller instance:

for instance in k8s-master; do
  gcloud compute scp ca.pem ca-key.pem kubernetes-key.pem kubernetes.pem \
    service-account-key.pem service-account.pem ${instance}:~/
done