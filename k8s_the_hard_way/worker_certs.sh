# redo for vagrant

for instance in worker-1 worker-2 worker-3; do
cat > ${instance}-csr.json <<EOF
{
  "CN": "system:node:${instance}",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "system:nodes",
      "OU": "Kubernetes The Hard Way",
      "ST": "Oregon"
    }
  ]
}
EOF

IP=$(vagrant ssh ${instance} -- hostname -I| tr ' ' \,)

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -hostname=${IP}${instance} \
  -profile=kubernetes \
  ${instance}-csr.json | cfssljson -bare ${instance}
done