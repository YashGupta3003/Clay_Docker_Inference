# Comprehensive Docker Setup Guide for Clay Foundation Model

This guide will walk you through the complete process of setting up and running the Clay Foundation model in a Docker container with Jupyter notebooks.

## Table of Contents
1. [Installing Docker](#1-installing-docker)
2. [Installing Repository](#2-installing-repository)
3. [Building the Container](#3-building-the-container)
4. [Setting Up Notebooks](#4-setting-up-notebooks)
5. [Running the Container](#5-running-the-container)
6. [Running the Notebook](#6-running-the-notebook)
7. [Downloading Model Weights](#7-downloading-model-weights)

---

## 1. Installing Docker

### For Linux (Ubuntu/Debian)
```bash
# Update package index
sudo apt-get update

# Install prerequisites
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Set up stable repository
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Add user to docker group (to run docker without sudo)
sudo usermod -aG docker $USER

# Start Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Log out and log back in for group changes to take effect
# Or run: newgrp docker
```

### For Windows
1. **Download Docker Desktop**: Visit [https://www.docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop)
2. **Install Docker Desktop**: Run the installer and follow the setup wizard
3. **Enable WSL 2**: Docker Desktop will prompt you to enable WSL 2 if not already enabled
4. **Restart**: Restart your computer after installation
5. **Verify Installation**: Open Docker Desktop and ensure it's running

### Verify Docker Installation
```bash
docker --version
docker run hello-world
```

---

## 2. Installing Repository

### Clone the Repository
```bash
# Navigate to your desired directory
cd ~/Desktop

# Clone the repository
git clone https://github.com/YashGupta3003/Clay_Docker_Inference.git
cd Clay_Docker_Inference

# Verify the contents
ls -la
```

**Expected Structure:**
```
Clay_Docker_Inference/
├── Dockerfile
├── procesing_inference.ipynb
└── README.md
```

---

## 3. Building the Container

### Build the Docker Image
```bash
# Make sure you're in the repository directory
cd ~/Desktop/Clay_Docker_Inference

# Build the Docker image
docker build -t clay-base .


**Note:** The build process may take 30-40 minutes depending on your internet connection and system performance.

---

## 4. Setting Up Notebooks

### Verify Notebooks Directory Creation
After building the Docker container, the `notebooks` folder will be created automatically. Let's verify:
```bash
# Check if notebooks folder exists after build
ls -la

# The notebooks folder should now be present
ls -la notebooks/
```

### Move Your Notebook to Notebooks Folder
```bash
# Move the notebook to the notebooks folder
mv procesing_inference.ipynb notebooks/
```

---

## 5. Running the Container

### Start the Container
```bash
# Run the container with port mapping
docker run -d \
  --name clay-jupyter \
  -p 8888:8888 \
  -v $(pwd)/notebooks:/workspace/notebooks \
  clay-base



### Get Jupyter Access Token
```bash
# View container logs to get the access token
docker logs clay-jupyter

# Look for a line like:
# http://127.0.0.1:8888/?token=abc123def456...
```

---

## 6. Running the Notebook

### Access Jupyter Notebook
1. **Open your web browser**
2. **Navigate to**: `http://localhost:8888`
3. **Enter the token** from the container logs
4. **Navigate to the notebooks folder**
5. **Open**: `procesing_inference.ipynb`

### Run Individual Cells
1. **Select a cell** by clicking on it
2. **Run the cell** using:
   - `Shift + Enter` (run and move to next)
   - `Ctrl + Enter` (run and stay)
   - Click the "Run" button in the toolbar

### Important Notes
- **First run may take longer** as packages are loaded
- **Some cells may require the model weights** (see step 7)
- **Monitor the terminal** for any error messages

---

## 7. Downloading Model Weights

### Download the Model from Terminal
From your host machine terminal (not in the Jupyter notebook), download the model weights:
```bash
# Navigate to the notebooks folder
cd notebooks/

# Download the Clay model weights
wget -q https://huggingface.co/made-with-clay/Clay/resolve/main/v1.5/clay-v1.5.ckpt

# Verify the download
ls -la clay-v1.5.ckpt
```

### Verify the Setup
```bash
# Check the notebooks folder contains all necessary files
ls -la notebooks/
```

**Expected files:**
- `procesing_inference.ipynb`
- `clay-v1.5.ckpt`
- `notebooks/` folder (created after Docker build)

---
