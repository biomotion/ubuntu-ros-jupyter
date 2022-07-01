FROM nvidia/cuda:10.2-cudnn8-devel-ubuntu18.04

ARG USERNAME=user
ARG USERPASS=user
ARG UID=1000
ARG GID=1000

# setup timezone
RUN echo 'Etc/UTC' > /etc/timezone && \
    ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime 

# install packages
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -q -y --no-install-recommends \
    dirmngr \
    gnupg2 \
    tzdata \
    locate \
    sudo \
    net-tools \
    vim \
    git \
    chromium-browser \
    openssh-client \
    terminator \
    && rm -rf /var/lib/apt/lists/*

# setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

############### Xfce & VNC ##############################

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        xfce4 xfce4-terminal \
    && apt-get purge -y \
        pm-utils \
        xscreensaver* \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        tigervnc-standalone-server

############### ROS Installation ########################
# setup keys
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
# setup sources.list
RUN echo "deb http://packages.ros.org/ros/ubuntu bionic main" > /etc/apt/sources.list.d/ros1-latest.list

ENV ROS_DISTRO melodic
# install ros packages
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ros-melodic-desktop=1.4.1-0* \
    && rm -rf /var/lib/apt/lists/*


################ Python Environment ######################

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y python2.7-dev python2.7 python-pip \
    && rm -rf /var/lib/apt/lists/*

COPY ./requirements.txt /tmp/

RUN pip install -U pip \
    && pip install jupyter \
    && pip install -r /tmp/requirements.txt

################ Create User ###########################
RUN groupadd -g $GID -o $USERNAME &&\
    useradd -m -s /bin/bash -u $UID -g $GID $USERNAME && \
    adduser $USERNAME sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER $USERNAME
ENV USER=$USERNAME \
    VNC_COL_DEPTH=24 \
    VNC_RESOLUTION=1280x1024
WORKDIR /home/$USERNAME

COPY ./startup.sh /
ENTRYPOINT ["/startup.sh"]
CMD ["bash"]
