#!/bin/bash
# -------------------------------------------------------------
# Setup del entorno para la plataforma HPC
# SO: Ubuntu 22.04 LTS (WSL2)
# Herramientas: Docker, kubectl, Minikube, Helm, Argo CLI
# -------------------------------------------------------------

set -e  # Detiene el script si algún comando falla

echo ">>> Iniciando instalación del entorno HPC..."

# -------------------------------------------------------------
# 1. Instalar Docker
# -------------------------------------------------------------
echo ">>> Instalando Docker..."
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg

sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo usermod -aG docker $USER
echo ">>> Docker instalado correctamente"

# -------------------------------------------------------------
# 2. Instalar kubectl
# -------------------------------------------------------------
echo ">>> Instalando kubectl..."
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.35/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.35/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubectl
echo ">>> kubectl instalado correctamente"

# -------------------------------------------------------------
# 3. Instalar Minikube
# -------------------------------------------------------------
echo ">>> Instalando Minikube..."
curl -LO https://github.com/kubernetes/minikube/releases/download/v1.38.1/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64
echo ">>> Minikube instalado correctamente"

# -------------------------------------------------------------
# 4. Instalar Helm
# -------------------------------------------------------------
echo ">>> Instalando Helm..."
cd ~
curl -LO https://get.helm.sh/helm-v4.1.4-linux-amd64.tar.gz
tar -zxvf helm-v4.1.4-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm
rm -rf linux-amd64 helm-v4.1.4-linux-amd64.tar.gz
echo ">>> Helm instalado correctamente"

# -------------------------------------------------------------
# 5. Instalar Argo CLI
# -------------------------------------------------------------
echo ">>> Instalando Argo CLI..."
curl -sLO "https://github.com/argoproj/argo-workflows/releases/download/v4.0.4/argo-linux-amd64.gz"
gunzip argo-linux-amd64.gz
chmod +x argo-linux-amd64
sudo mv argo-linux-amd64 /usr/local/bin/argo
echo ">>> Argo CLI instalado correctamente"

# -------------------------------------------------------------
# 5. Verificar instalaciones...
# -------------------------------------------------------------
echo ""
echo ">>> Verificando instalaciones..."
echo "--------------------------------------"
echo "Docker:"
docker --version
echo "--------------------------------------"
echo "kubectl:"
kubectl version --client
echo "--------------------------------------"
echo "Minikube:"
minikube version
echo "--------------------------------------"
echo "Helm:"
helm version
echo "--------------------------------------"
echo "Argo CLI:"
argo version
echo "--------------------------------------"
echo ">>> Setup completado con éxito!"
echo ">>> Arranca el clúster con: minikube start --driver=docker --cpus=2 --memory=3072"
