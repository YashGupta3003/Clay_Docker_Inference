# Lightweight Dockerfile for Clay Foundation Model Development
# Using Python slim image for smaller footprint
FROM python:3.11.13-slim


# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV PIP_NO_CACHE_DIR=1
ENV PIP_DISABLE_PIP_VERSION_CHECK=1

# Install minimal system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    build-essential \
    libgdal-dev \
    gdal-bin \
    libgeos-dev \
    libproj-dev \
    libspatialindex-dev \
    ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create workspace
WORKDIR /workspace

# Clone the Clay Foundation model repository
RUN git clone --depth 1 https://github.com/Clay-foundation/model.git /clay-model

# Set GDAL environment variables
ENV CPLUS_INCLUDE_PATH=/usr/include/gdal
ENV C_INCLUDE_PATH=/usr/include/gdal

# Install core Python packages (CPU-only PyTorch for lighter footprint)
# RUN pip install --no-cache-dir \
#     torch==2.0.1 --index-url https://download.pytorch.org/whl/cpu \
#     torchvision==0.15.2 --index-url https://download.pytorch.org/whl/cpu

# Uninstall numpy to avoid conflicts with geospatial packages
RUN pip uninstall numpy -y 

# Install essential geospatial packages
RUN pip install --no-cache-dir \
    numpy \
    pandas \
    matplotlib \
    rasterio \
    geopandas \
    shapely \
    xarray \
    rioxarray \
    einops \
    timm\
    pillow \
    pystac_client \
    stackstac \
    pyproj \
    python-box \
    scikit-learn


# Install Jupyter essentials only
RUN pip install --no-cache-dir \
    jupyter \
    notebook \
    ipykernel \
    ipywidgets

# Install Clay model dependencies
WORKDIR /workspace/clay-model
RUN pip install git+https://github.com/Clay-foundation/model.git 


# Create notebooks directory
RUN mkdir -p /workspace/notebooks

# Simple Jupyter configuration
RUN jupyter notebook --generate-config && \
    echo "c.NotebookApp.ip = '0.0.0.0'" >> ~/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.allow_root = True" >> ~/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.open_browser = False" >> ~/.jupyter/jupyter_notebook_config.py

# Expose Jupyter port
EXPOSE 8888

# Set working directory
WORKDIR /workspace

# Start Jupyter directly
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]
