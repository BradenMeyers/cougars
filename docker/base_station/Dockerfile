# Install development dependencies (rqt, plotjuggler, documentation, etc.)
USER root
RUN if [ "$TARGETARCH" = "amd64" ]; then \
    apt update && apt install -y \
    libx11-dev \
    libxext-dev \
    libxrender-dev \
    libxrandr-dev \
    qtbase5-dev \
    libqt5x11extras5 \
    python3-gi \
    gir1.2-gtk-3.0 \
    x11-apps \
    ros-humble-rqt* \
    ros-humble-plotjuggler-ros \
    ros-humble-rviz2 \
    python3-rosdoc2 \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*; \
    fi
USER ${LABNAME}


# Install development Python dependencies
RUN if [ "$TARGETARCH" = "amd64" ]; then \
    pip3 install --no-cache-dir PyQt5; \
    fi