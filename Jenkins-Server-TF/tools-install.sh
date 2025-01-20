#!/bin/bash
# Script for automating GCP instance setup on Ubuntu 22.04

# Update system packages
sudo apt update -y && sudo apt upgrade -y

# Install Java (required for Jenkins)
sudo apt install openjdk-17-jre -y
sudo apt install openjdk-17-jdk -y
java --version

# Add Jenkins repository and install Jenkins
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update -y
sudo apt-get install jenkins -y

# Start and enable Jenkins service
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Install Docker
sudo apt install docker.io -y
sudo usermod -aG docker jenkins
sudo usermod -aG docker $USER
sudo systemctl restart docker
sudo chmod 777 /var/run/docker.sock

# Run Docker container for SonarQube
docker run -d --name sonar -p 9000:9000 sonarqube:lts-community

# Install Google Cloud SDK (gcloud CLI)
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
sudo apt-get update && sudo apt-get install google-cloud-cli -y

# Add gcloud to PATH and reinitialize environment
echo "export PATH=\$PATH:/usr/lib/google-cloud-sdk/bin" >> ~/.bashrc
source ~/.bashrc

# Verify gcloud installation
gcloud version || { echo "gcloud CLI installation failed!"; exit 1; }

# Install kubectl
sudo apt update
sudo apt install curl -y
sudo curl -LO "https://dl.k8s.io/release/v1.28.4/bin/linux/amd64/kubectl"
sudo chmod +x kubectl
sudo mv kubectl /usr/local/bin/
kubectl version --client || { echo "kubectl installation failed!"; exit 1; }

# Install Terraform
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update
sudo apt install terraform -y
terraform version || { echo "Terraform installation failed!"; exit 1; }

# Install Trivy
sudo apt-get install wget apt-transport-https gnupg lsb-release -y
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo gpg --dearmor -o /usr/share/keyrings/trivy-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/trivy-archive-keyring.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/trivy.list
sudo apt update
sudo apt install trivy -y
trivy --version || { echo "Trivy installation failed!"; exit 1; }

# Install Helm
sudo snap install helm --classic
helm version || { echo "Helm installation failed!"; exit 1; }

# Verify installations
echo "Verifying installations..."
java --version
gcloud version
kubectl version --client
terraform version
trivy --version
helm version

echo "GCP instance automation setup completed successfully!"