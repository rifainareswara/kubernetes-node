Saya bisa membuatkan template AWS CloudFormation untuk membuat EKS cluster dengan nama "kube-node". CloudFormation adalah layanan infrastruktur sebagai kode (IaC) bawaan AWS sebagai alternatif untuk Terraform. Berikut ini cara menyiapkan dan menggunakan CloudFormation untuk EKS:

## Panduan Menggunakan CloudFormation untuk EKS

Berikut langkah-langkah untuk men-deploy EKS cluster menggunakan CloudFormation:

### 1. Persiapan File CloudFormation

Saya telah membuat template CloudFormation untuk EKS "kube-node". Simpan file `kube-node-cloudformation.yaml` ke komputer Anda.

### 2. Men-deploy Stack CloudFormation

#### Cara menggunakan AWS Management Console:

1. Buka konsol AWS dan masuk ke layanan CloudFormation
2. Klik tombol "Create stack" → "With new resources (standard)"
3. Pada bagian "Specify template", pilih "Upload a template file"
4. Klik "Choose file" dan pilih file `kube-node-cloudformation.yaml` yang telah disimpan
5. Klik "Next"
6. Isi nama stack, misalnya "kube-node-stack"
7. Jika ingin, ubah parameter default
8. Klik "Next"
9. Atur opsi stack tambahan (opsional) lalu klik "Next"
10. Periksa semua konfigurasi dan klik "Create stack"

#### Cara menggunakan AWS CLI:

```bash
aws cloudformation create-stack \
  --stack-name kube-node-stack \
  --template-body file://kube-node-cloudformation.yaml \
  --capabilities CAPABILITY_IAM
```

### 3. Memeriksa Status Deployment

Proses pembuatan akan memakan waktu sekitar 15-20 menit. Anda dapat memantau prosesnya melalui:

- **AWS Console**: Buka CloudFormation → Pilih stack "kube-node-stack" → Tab "Events"
- **AWS CLI**:
  ```bash
  aws cloudformation describe-stacks --stack-name kube-node-stack
  ```

### 4. Konfigurasi kubectl (setelah berhasil deploy)

Setelah deployment selesai, konfigurasi kubectl dengan perintah:

```bash
aws eks update-kubeconfig --name kube-node --region ap-southeast-1
```

## Cara Menghapus Stack CloudFormation

Ketika Anda ingin menghapus EKS cluster dan semua sumber dayanya:

### 1. Melalui AWS Management Console:

1. Buka konsol AWS dan masuk ke layanan CloudFormation
2. Pilih stack "kube-node-stack"
3. Klik "Delete"
4. Konfirmasi dengan mengklik "Delete stack"

### 2. Melalui AWS CLI:

```bash
aws cloudformation delete-stack --stack-name kube-node-stack
```

Proses penghapusan membutuhkan waktu sekitar 10-15 menit. Anda dapat memantau statusnya di konsol CloudFormation atau dengan perintah:

```bash
aws cloudformation describe-stacks --stack-name kube-node-stack
```

## Catatan Penting

- Template CloudFormation ini membuat EKS cluster di region yang sedang aktif pada profil AWS Anda. Pastikan Anda telah mengatur region ke `ap-southeast-1` (Singapore).
- Jika terjadi error selama penghapusan, beberapa sumber daya mungkin perlu dihapus secara manual dari AWS Console.
- Pastikan IAM User atau Role yang Anda gunakan memiliki izin yang cukup untuk membuat dan menghapus semua sumber daya yang diperlukan.