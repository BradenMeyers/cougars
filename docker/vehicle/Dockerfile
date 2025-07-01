# FROM ubuntu:22.04
FROM ros:humble-ros-base

ARG LABNAME=frostlab
ARG DEBIAN_FRONTEND=noninteractive

# TODO remove apt lists afer every RUN
# DO WE NEED THIS?
# RUN mkdir -p -m0755 /etc/apt/keyrings
USER root

# ty tools
RUN apt update && apt install -y \
    curl \
    wget \
    unzip \
    build-essential \
    git \
    locales \
    software-properties-common \
    python3-venv \
    libboost-all-dev \
    cmake \ 
    python3-pip
# TODO remove apt lists


# Set up a new user
RUN useradd -ms /bin/bash ${LABNAME} \
    && usermod -aG sudo ${LABNAME} \
    && usermod -aG dialout ${LABNAME} \
    && echo "${LABNAME}:${LABNAME}" | chpasswd 


RUN curl https://download.koromix.dev/debian/koromix-archive-keyring.gpg -o /etc/apt/keyrings/koromix-archive-keyring.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/koromix-archive-keyring.gpg] https://download.koromix.dev/debian stable main" > /etc/apt/sources.list.d/koromix.dev-stable.list \
    && apt update && apt install -y tytools


    # Install Python dependencies
RUN pip3 install numpy==1.24.0 \
    scipy \
    matplotlib \
    pyproj \
    pymavlink \
    ruamel.yaml \ 
    tmuxp \ 
    pybind11_stubgen


# INSTALL GTSAM
WORKDIR /home/${LABNAME}/
RUN git clone --depth 1 https://github.com/borglab/gtsam.git && \
    mkdir /home/${LABNAME}/gtsam/build && \
    wget -O Eigen.zip https://gitlab.com/libeigen/eigen/-/archive/3.4.0/eigen-3.4.0.zip && \
    unzip Eigen.zip \
    && mv eigen-3.4.0/Eigen /usr/local/include \
    && rm -rf eigen-3.4.0 Eigen.zip

WORKDIR /home/${LABNAME}/gtsam/build 
RUN cmake .. -DGTSAM_BUILD_PYTHON=ON -DGTSAM_PYTHON_VERSION=3.10.12 \
    && make -j"$(nproc)" python-install

    
    
WORKDIR /home/${LABNAME}
# Install PlatformIO
RUN curl -fsSL -o get-platformio.py https://raw.githubusercontent.com/platformio/platformio-core-installer/master/get-platformio.py \
    && python3 get-platformio.py \
    && rm -f get-platformio.py

# Set up PlatformIO shell commands
RUN install -d /usr/local/bin && \
    ln -s /home/${LABNAME}/.platformio/penv/bin/platformio /usr/local/bin/platformio && \
    ln -s /home/${LABNAME}/.platformio/penv/bin/pio /usr/local/bin/pio && \
    ln -s /home/${LABNAME}/.platformio/penv/bin/piodebuggdb /usr/local/bin/piodebuggdb

# Install ROS2
# RUN locale-gen en_US en_US.UTF-8 \
#     && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 \
#     && add-apt-repository universe \ 
#     && curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg \
#     && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null \
#     && apt update \
#     && apt install -y ros-humble-ros-base

# ENV LANG=en_US.UTF-8


# Install dependencies
RUN apt update && apt install -y \
    vim \
    psmisc \
    network-manager \
    systemd \
    libgps-dev \
    python3-libgpiod \
    # ros-humble-rosbag2-storage-mcap \
    netcat-openbsd \
    rsync \
    libserialport-dev \ 
    gpsd-clients \
    tmux \
    ros-humble-gps-msgs \
    ros-humble-gpsd-client \
    && rm -rf /var/lib/apt/lists/*



# Set up bash variable sourcing (Make sure this exists as a volume when you run the container!)
RUN echo "source /home/${LABNAME}/config/cougarsrc.sh" >> ~/.bashrc \
    && echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc \    
    && echo "export RCUTILS_COLORIZED_OUTPUT=1" >> ~/.bashrc \
    && touch ~/.hushlogin \
    && mkdir -p /home/${LABNAME}/.ssh \
    && chmod 700 /home/${LABNAME}/.ssh 

USER ${LABNAME}
WORKDIR /home/${LABNAME}