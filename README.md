# Pytorch docker with SSH enabled

## Intro

This repo intends to enable SSH remote debug for pytorch dockers. 

NVIDIA provides ready-to-use Docker images for Pytorch in [NGC](https://catalog.ngc.nvidia.com/), eliminating the need for users to manually install different versions of CUDA, cuDNN, and Pytorch, etc.
However, most remote debug tools do not offer good support for running docker containers remotely. They typically connect directly to the remote environment via SSH.

This repository provides some simple Dockerfiles to help you enable SSH services within the docker images provided by NVIDIA, while also **importing all environment variables into the SSH terminal**. These environment variables are typically introduced through the `ENV` statement when building docker images and are invisible when connected via SSH.

## Usage

0. To pull docker images from NGC, you might need to login to NGC and set API key in your host machine. Please refer to [NGC](https://catalog.ngc.nvidia.com/). Also, [nvidia-container-toolkit](https://github.com/NVIDIA/nvidia-container-toolkit) is needed to enable docker support of GPU.

1. Run `docker build -f Dockerfile.torch2.1+cu122 -t pytorch_with_ssh:2.1-cu122 .` on the host machine. Switch `Dockerfile.torch2.1+cu122` to the exact version you need. If it is not listed here, you can explore [pytorch images](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/pytorch) and [support matrix](https://docs.nvidia.com/deeplearning/frameworks/support-matrix/index.html), and edit the `FROM` statement in the Dockerfile accordingly.

2. After building, run  `docker run --name={container name} -d --restart=unless-stopped -p {ssh_port}:22 --ipc=host pytorch_with_ssh:2.1-cu122`, and use a SSH terminal to connect `host_ip:{ssh_port}` with username `root` and password `123456`. You can add `-v` to mount directories or files to the docker, or add `-p` to open more desired ports.

3. When first connecting to the container,  run `/opt/nvidia/nvidia_entrypoint.sh`  to read the license information and run the self-check offered by NVIDIA. Follow the instructions if any warnings are given during self-check. Note for early images, the script's path may differ. In that case, read the `ENTRYPOINT` in the Dockerfile (Layers) on its [release page](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/pytorch) to get the script's path.

## Safety Reminder

These dockerfiles are designed to **personal use** within **safe local network**. If it's not your case, please **do not** use these docker images unless you know exactly what you are doing.