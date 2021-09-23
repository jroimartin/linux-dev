# SPDX-License-Identifier: GPL-2.0

# Build:
#
# docker build \
#   [--build-arg UBUNTU_VERSION=<ubuntu_version>] \
#   [--build-arg USER_ID=<host_uid>] \
#   [--build-arg GROUP_ID=<host_gid>] \
#   [--build-arg USERNAME=<username>] \
#   -t kerneldev-ubuntu:<ubuntu_version> .
#
# Run:
#
# docker run \
#   -ti --rm \
#   -v <kernel_path>:<kernel_path> \
#   kerneldev-ubuntu:<ubuntu_version>

ARG UBUNTU_VERSION=18.04

FROM ubuntu:${UBUNTU_VERSION}

ARG USER_ID=1000
ARG GROUP_ID=1000
ARG USERNAME=kerneldev

RUN apt-get update
RUN apt-get install -y build-essential git libncurses5-dev bc systemtap \
	flex bison libssl-dev openssl cpio libelf-dev rsync
RUN apt-get install -y lz4 || \
	apt-get install -y liblz4-tool || \
	echo 'warning: could not install z4'
RUN apt-get install -y kmod || \
	echo 'warning: could not install kmod'
RUN apt-get clean

RUN groupadd -g ${GROUP_ID} ${USERNAME} && \
    useradd -u ${USER_ID} -g ${USERNAME} -m ${USERNAME}

USER ${USERNAME}
