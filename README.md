Mari kita bahas setiap langkah secara mendetail:

---

## **1. Persiapan Lingkungan**
### **Instalasi Tools**
- **AWS CLI**: Untuk berinteraksi dengan AWS dari terminal.
- **Terraform**: Untuk infrastruktur sebagai kode.
- **kubectl**: CLI untuk berinteraksi dengan Kubernetes.
- **Docker**: Untuk containerisasi aplikasi.
- **eksctl**: Untuk membuat dan mengelola cluster EKS.

### **Instalasi di Mac:**
```bash
brew install awscli terraform kubectl eksctl docker
```

---

## **2. Buat Aplikasi Sederhana**
### **Struktur Project Tree**
```
my-app/
│
├── app.js
├── Dockerfile
├── package.json
├── package-lock.json
└── README.md
```

### **Kode untuk Aplikasi Node.js (`app.js`)**
```javascript
const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
  res.send('Hello, Kubernetes!');
});

app.listen(port, () => {
  console.log(`App running on port ${port}`);
});
```

### **Inisialisasi Project**
```bash
npm init -y
npm install express
```

### **Dockerfile**
```dockerfile
FROM node:14
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["node", "app.js"]
```

### **Build Docker Image**
```bash
docker build -t my-app .
```

### **Push ke Docker Hub atau Amazon ECR**
- Login ke Docker Hub atau ECR:
```bash
docker login
```

- Tag dan push image:
```bash
docker tag my-app:latest <repository-url>:latest
docker push <repository-url>:latest
```

---

## **3. Provisioning Cluster Kubernetes dengan Terraform**
### **Struktur Project Terraform**
```
terraform-eks/
│
├── main.tf
├── variables.tf
├── security.tf
└── network.tf
└── iam.tf
```


### **Inisialisasi dan Deploy Cluster**
```bash
terraform init
terraform apply
```

---

## **4. Konfigurasi kubectl untuk EKS**
```bash
aws eks --region ap-southeast-1 update-kubeconfig --name kube-node
```
```
aws eks update-kubeconfig --name kube-node --region ap-southeast-1
```
**Verifikasi bahwa token autentikasi Anda valid**
```
aws sts get-caller-identity
```

---

## **5. Deploy Aplikasi ke Kubernetes**
### **Deployment File (`deployment.yaml`)**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: kube-noode
spec:
  replicas: 2
  selector:
    matchLabels:
      app: kube-node
  template:
    metadata:
      labels:
        app: kube-node
    spec:
      containers:
      - name: kube-node
        image: rnrifai/kube-node:latest
        ports:
        - containerPort: 3000
```

### **Deploy ke Kubernetes**
```bash
kubectl apply -f deployment.yaml
```

---

## **6. Ekspos Layanan dengan Service**
### **Service File (`service.yaml`)**
```yaml
apiVersion: v1
kind: Service
metadata:
  name: kube-node-service
spec:
  type: LoadBalancer
  selector:
    app: kube-node
  ports:
    - protocol: TCP
      port: 80
      targetPort: 3000
```

### **Deploy Service**
```bash
kubectl apply -f service.yaml
```
```
kubectl delete deployment --all
```

---

## **7. Verifikasi Deployment**
```bash
kubectl get pods
kubectl get services
```

Dapatkan IP dari LoadBalancer untuk mengakses aplikasi.

---

`<repository-url>:latest` adalah sintaks yang digunakan untuk mereferensikan image Docker yang akan digunakan atau di-push ke suatu container registry, seperti Docker Hub atau Amazon Elastic Container Registry (ECR).

### **Penjelasan Detail**:
1. **`<repository-url>`**: URL dari repository tempat image Docker disimpan. Ini bisa berupa:
   - Docker Hub: `username/my-app`
   - Amazon ECR: `123456789012.dkr.ecr.us-east-1.amazonaws.com/my-app`
   - Google Container Registry (GCR): `gcr.io/my-project/my-app`
   - Private Docker registry: `my-registry.com/my-app`

2. **`:latest`**: Tag yang digunakan untuk menandai versi image.
   - Secara default, jika kamu tidak menentukan tag, Docker akan menggunakan `:latest`.
   - Tag ini sering digunakan untuk menandai versi terbaru, tetapi dalam lingkungan produksi, sebaiknya gunakan tag versi spesifik untuk menghindari ketidakpastian versi yang digunakan.

### **Contoh Praktis**:
Jika kamu sudah build image dengan nama `my-app`, lalu ingin mendorongnya ke Docker Hub:

```bash
docker tag my-app:latest my-dockerhub-username/my-app:latest
docker push my-dockerhub-username/my-app:latest
```

Atau jika menggunakan Amazon ECR:

```bash
docker tag my-app:latest 123456789012.dkr.ecr.us-east-1.amazonaws.com/my-app:latest
docker push 123456789012.dkr.ecr.us-east-1.amazonaws.com/my-app:latest
```

---

### **Mengapa `latest` Tidak Direkomendasikan di Produksi?**
- Tidak ada jaminan versi yang konsisten, yang dapat menyebabkan bug sulit ditelusuri.
- Lebih baik menggunakan versi spesifik seperti `v1.0.0`, `v2.1.3`, dll.


