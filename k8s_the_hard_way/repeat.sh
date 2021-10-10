for instance in worker-1 worker-2 worker-3; do 
kubectl config set-cluster k8s-the-hard-way \
--certificate-authority=ca.pem \
--embed-certs=true \
--server=https://${KUBERNETES_PUBLIC_ADDRESS}:6443 \
--kubeconfig=${instance}.kubeconfig 

kubectl config set-credentials system:node:${instance} \
--client-certificate=${instance}.pem \
--client-key=${instance}-key.pem \
--embed-certs=true \
--kubeconfig=${instance}.kubeconfig 

kubectl config set-context default \
--cluster=k8s-the-hard-way \
--user=system:node:${instance} \
--kubeconfig=${instance}.kubeconfig 

kubectl config use-context default \
--kubeconfig=${instance}.kubeconfig

 done