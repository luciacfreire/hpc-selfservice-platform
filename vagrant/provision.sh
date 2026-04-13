#!/bin/bash
# --------------------------------------------------------------
# Aprovisionamiento de la VM para la plataforma HPC
# SO: Rocky Linux 9
# Herramientas: Docker, kubectl, Minikube, Helm, Argo CLI
# --------------------------------------------------------------

set -e  # Detiene el script si algún comando falla

# --------------------------------------------------------------
# 1. Actualizar el sistema
# --------------------------------------------------------------

echo ">>> Actualizando el sistema..."
dnf update -y
dnf install -y epel-release
dnf install -y curl wget git tar bash-completion

# --------------------------------------------------------------
# 2. Instalar Docker
# --------------------------------------------------------------
echo ">>> Instalando Docker..."
dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
dnf install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Habilitar y arrancar Docker
systemctl enable docker
systemctl start docker
# Añadir el usuario vagrant al grupo docker - evita usar sudo
usermod -aG docker vagrant

# --------------------------------------------------------------
# 3. Instalar kubectl
# --------------------------------------------------------------
echo ">>> Instalando kubectl..."

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.35/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.35/rpm/repodata/repomd.xml.key
EOF

dnf install -y kubectl

# --------------------------------------------------------------
# 4. Instalar Minikube
# --------------------------------------------------------------
echo ">>> Instalando Minikube..."

curl -LO https://github.com/kubernetes/minikube/releases/download/v1.38.1/minikube-linux-amd64
install -o root -g root -m 0755 minikube-linux-amd64 /usr/local/bin/minikube
rm -f minikube-linux-amd64

# --------------------------------------------------------------
# 5. Instalar Helm
# --------------------------------------------------------------
echo ">>> Instalando Helm..."

curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# --------------------------------------------------------------
# 6. Instalar Argo CLI
# --------------------------------------------------------------
echo ">>> Instalando Argo CLI..."

curl -sLO "https://github.com/argoproj/argo-workflows/releases/download/v4.0.4/argo-linux-amd64.gz"
gunzip "argo-linux-amd64.gz"
chmod +x "argo-linux-amd64"
mv "./argo-linux-amd64" /usr/local/bin/argo
argo version

# --------------------------------------------------------------
# 7. Verificar instalaciones
# --------------------------------------------------------------
echo ""
echo ">>> Verificando instalaciones..."
echo "--------------------------------------"
echo "Docker version:"
docker --version
echo "--------------------------------------"
echo "kubectl version:"
kubectl version --client
echo "--------------------------------------"
echo "Minikube version:"
minikube version
echo "--------------------------------------"
echo "Helm version:"
helm version
echo "--------------------------------------"
echo "Argo CLI version:"
argo version
echo "--------------------------------------"
echo ">>> Aprovisionamiento completado con éxito!"
echo ">>> Puedes entrar a la VM con 'vagrant ssh'"