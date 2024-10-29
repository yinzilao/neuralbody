# FROM nvidia/cuda:11.1.1-cudnn8-devel-ubuntu18.04
FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu18.04

# For the convenience for users in China mainland
# COPY docker/apt-sources.list /etc/apt/sources.list

# Force IPv4 
RUN echo 'Acquire::ForceIPv4 "true";' > /etc/apt/apt.conf.d/99force-ipv4
# Use main Ubuntu archive
# RUN sed -i 's|archive.ubuntu.com|archive.ubuntu.com|g' /etc/apt/sources.list

# German mirror
RUN sed -i 's|archive.ubuntu.com|de.archive.ubuntu.com|g' /etc/apt/sources.list

# Install some basic utilities
RUN rm -f /etc/apt/sources.list.d/nvidia-ml.list \
 && rm -f /etc/apt/sources.list.d/cuda.list \
 && apt-get update \
 && apt-get install -y --fix-missing --no-install-recommends \
    curl \
    ca-certificates \
    sudo \
    git \
    bzip2 \
    libx11-6 \
    gcc \
    g++ \
    libusb-1.0-0 \
    cmake \
    libssl-dev \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y python3-opencv \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Create a working directory
RUN mkdir /app
WORKDIR /app

# Create a non-root user and switch to it
RUN adduser --disabled-password --gecos '' --shell /bin/bash user \
 && chown -R user:user /app
RUN echo "user ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-user
USER user

# All users can use /home/user as their home directory
ENV HOME=/home/user
RUN chmod 777 /home/user

# Use a specific older version of Mambaforge and Python 3.8
ENV CONDA_AUTO_UPDATE_CONDA=false
ENV PATH="/home/user/mambaforge/bin:$PATH"
RUN curl -sLo /home/user/mambaforge.sh https://github.com/conda-forge/miniforge/releases/download/4.10.3-10/Mambaforge-4.10.3-10-Linux-x86_64.sh \
 && chmod +x /home/user/mambaforge.sh \
 && /home/user/mambaforge.sh -b -p /home/user/mambaforge \
 && rm /home/user/mambaforge.sh \
 && mamba install -y python==3.8.3 \
 && mamba clean -ya

# CUDA 11.8-specific steps
RUN mamba install -y -c conda-forge cudatoolkit=11.8 \
 && mamba install -y -c pytorch -c nvidia\
    "pytorch=2.0.0=py3.8_cuda11.8_cudnn8.7.0_0" \
    "torchvision=0.15.0=py38_cu118" \
 && mamba clean -ya

# Install dependencies
# COPY environment.yml environment.yml
# RUN mamba env update -n base --file environment.yml \
#  && mamba clean -ya

RUN pip config set global.index-url https://pypi.org/simple
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt
RUN mamba install -y -c conda-forge -c python \
   numpy \
   Cython \
   scikit-image \
   && mamba clean -ya

 
# RUN pip install numpy \
#    && pip install Cython \
#    && pip install --no-binary :all: "scikit-image>=0.14.2" 
RUN pip install --upgrade trimesh
RUN pip uninstall -y PIL || true
RUN pip uninstall -y Pillow || true
RUN pip install Pillow
RUN pip install --upgrade imageio

# Add these environment variables before building spconv
ENV TORCH_CUDA_ARCH_LIST="6.0;6.1;7.0;7.5;8.0;8.6;8.9+PTX" \
    FORCE_CUDA=1 \
    CUDA_HOME=/usr/local/cuda \
    LD_LIBRARY_PATH="/usr/local/cuda/lib64:${LD_LIBRARY_PATH}"

# build spconv with pip
RUN pip uninstall -y spconv || true \
 && pip uninstall -y cumm || true \
 && pip install spconv-cu118

# fixing undefined symbol: iJIT_NotifyEvent
RUN pip install mkl==2024.0

# Check CUDA
RUN set -x && nvcc --version

CMD ["python3"]
