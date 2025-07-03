FROM frostlab/cougars:vehicle

USER root
RUN apt update && apt install -y \
    ros-humble-microstrain-inertial-driver \
    libglib2.0-dev 


# install LCM after libglib2.0-dev
WORKDIR /home/frostlab
RUN git clone https://github.com/lcm-proj/lcm.git
WORKDIR /home/frostlab/lcm
RUN mkdir build && cd build && \
    cmake .. && \
    make -j$(nproc) && make install && ldconfig


# Create i2c group with typical GID (if needed)
RUN groupadd -f -g 994 i2c && usermod -aG i2c frostlab
    
    
WORKDIR /home/frostlab