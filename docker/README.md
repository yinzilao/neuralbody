## 1. Build the image

From the root path of the project:
```shell
docker build -f docker/Dockerfile -t neuralbody .
```

For Ubuntu 24.04, temporarily you need to run:
```shell
sudo sysctl -w kernel.apparmor_restrict_unprivileged_userns=0
sudo systemctl restart docker
```

You may want to try several times since there are so many packages to be downloaded through the Internet and htpp(s) erros could occur.


### Upgrade to compatible versions for RTX 4090, 
#### Ubuntu 24.04 LTS
#### RTX 4090 supports cuda >= 11.8
nvidia/cuda:11.8.0-cudnn8-devel-ubuntu18.04
Upgrade to 11.8.0 for RTX 4090: 
    cuda 11.8.0
    cudnn 8.7.0
    pytorch 2.0.0
    torchvision 0.15.1
    python 3.8.3

## 2. Data preparation

The docker image contains the environment you need to run the project, while you still need to manually download data as described in [INSTALL.md](https://github.com/zju3dv/neuralbody/blob/master/INSTALL.md).

Note that the files downloaded are originally tar.gz files, while you need to extract each of them.

An example is like:

```shell
for name in $(ls *.tar.gz); do tar -xvf $name; done
```

## 3. Execution using docker containers


Suppose you are at the root path of the project, run a docker container like:
```shell
sudo docker run --runtime=nvidia -it --rm --gpus=all --shm-size=16G \
--mount type=bind,source="$(pwd)",target=/app \
--mount type=bind,source=<DATAPATH>,target=/app/data \
neuralbody <COMMAND>
```
where `<COMMAND>` can be obtained from [README.md](https://github.com/zju3dv/neuralbody/blob/master/README.md) and `<DATAPATH>` is your path for data.
