# FROM nvidia/cuda:11.1.1-cudnn8-devel-ubuntu18.04
FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu18.04

# For the convenience for users in China mainland
# COPY docker/apt-sources.list /etc/apt/sources.list

# Force IPv4 
RUN echo 'Acquire::ForceIPv4 "true";' > /etc/apt/apt.conf.d/99force-ipv4
# Use main Ubuntu archive
RUN sed -i 's|archive.ubuntu.com|archive.ubuntu.com|g' /etc/apt/sources.list

# German mirror
# RUN sed -i 's|archive.ubuntu.com|de.archive.ubuntu.com|g' /etc/apt/sources.list

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

# Use a specific older version of Mambaforge
RUN curl -sLo /home/user/mambaforge.sh https://github.com/conda-forge/miniforge/releases/download/4.10.3-10/Mambaforge-4.10.3-10-Linux-x86_64.sh \
 && chmod +x /home/user/mambaforge.sh \
 && /home/user/mambaforge.sh -b -p /home/user/mambaforge \
 && rm /home/user/mambaforge.sh

# Add Mambaforge to PATH. make the PATH modification permanent by using the ENV instruction. 
ENV PATH="/home/user/mambaforge/bin:$PATH"

# Install dependencies
COPY environment.yml environment.yml
RUN mamba env create -f environment.yml \
 && mamba clean -ya

ENV CUDA_HOME=/usr/local/cuda
RUN bash -c "git clone --recursive https://github.com/traveller59/spconv.git"

# We manually download and install cmake since the requirements of spconv is newer than
# that included in apt for ubuntu18.
RUN curl -sLo cmake.tar.gz https://github.com/Kitware/CMake/releases/download/v3.20.1/cmake-3.20.1.tar.gz \
 && tar -xvf cmake.tar.gz
RUN cd cmake-3.20.1 \
 && ./bootstrap \
 && make -j4 && sudo make install

RUN sudo apt-get update && sudo apt-get install -y libboost-dev \
 && sudo rm -rf /var/lib/apt/lists/*

# Activate the environment in subsequent RUN commands
SHELL ["conda", "run", "-n", "neuralbody", "/bin/bash", "-c"]

COPY docker/spconv.sh spconv.sh
RUN bash spconv.sh

CMD ["python3"]
