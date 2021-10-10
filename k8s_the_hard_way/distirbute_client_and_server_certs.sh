# Figure out the 
# The Kubernetes API Server Certificate
# before pushing it to the hosts
# 10.8.8.11 -????

KUBERNETES_PUBLIC_ADDRESS="10.8.8.11"

KUBERNETES_HOSTNAMES=kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster,kubernetes.svc.cluster.local

cat > kubernetes-csr.json <<EOF
{
  "CN": "kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "Kubernetes",
      "OU": "Kubernetes The Hard Way",
      "ST": "Oregon"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -hostname=10.8.8.11,10.8.8.12,${KUBERNETES_PUBLIC_ADDRESS},127.0.0.1,${KUBERNETES_HOSTNAMES} \
  -profile=kubernetes \
  kubernetes-csr.json | cfssljson -bare kubernetes



for instance in worker-1 worker-2 worker-3; do
  vagrant scp ca.pem /home/vagrant/ ${instance}
  vagrant scp ${instance}-key.pem /home/vagrant/ ${instance}
  vagrant scp ${instance}.pem /home/vagrant/  ${instance}
done
Copy the appropriate certificates and private keys to each controller instance:

for instance in k8s-master-1 k8s-master-2 ; do
  vagrant scp ca.pem /home/vagrant/ ${instance}
  vagrant scp ca-key.pem /home/vagrant/ ${instance}
  vagrant scp kubernetes-key.pem /home/vagrant/ ${instance}
  vagrant scp kubernetes.pem /home/vagrant/ ${instance}
  vagrant scp service-account-key.pem /home/vagrant/ ${instance}
  vagrant scp service-account.pem /home/vagrant/ ${instance}
done

for instance in worker-1 worker-2 worker-3; do
  vagrant scp ${instance}.kubeconfig /home/vagrant/ ${instance} 
  vagrant scp kube-proxy.kubeconfig /home/vagrant/ ${instance}
done
Copy the appropriate kube-controller-manager and kube-scheduler kubeconfig files to each controller instance:

for instance in k8s-master-1 k8s-master-2; do
  vagrant scp admin.kubeconfig /home/vagrant/ ${instance}
  vagrant scp kube-controller-manager.kubeconfig /home/vagrant/ ${instance}
  vagrant scp kube-scheduler.kubeconfig /home/vagrant/ ${instance}
done

for instance in k8s-master-1 k8s-master-2; do
  vagrant scp encryption-config.yaml /home/vagrant/ ${instance}
done


currnet step
https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/07-bootstrapping-etcd.md#configure-the-etcd-server