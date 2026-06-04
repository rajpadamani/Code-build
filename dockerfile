FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    make \
    ninja-build \
    python3 \
    python3-pip \
    git \
    wget \
    xz-utils \
    && rm -rf /var/lib/apt/lists/*


# Install ARM GCC toolchain
WORKDIR /opt

# RUN wget -q https://developer.arm.com/-/media/Files/downloads/gnu/12.3.rel1/binrel/arm-gnu-toolchain-12.3.rel1-x86_64-arm-none-eabi.tar.xz \
#     && tar -xf arm-gnu-toolchain-12.3.rel1-x86_64-arm-none-eabi.tar.xz \
#     && rm arm-gnu-toolchain-12.3.rel1-x86_64-arm-none-eabi.tar.xz

RUN wget https://developer.arm.com/-/media/Files/downloads/gnu/13.2.rel1/binrel/\
arm-gnu-toolchain-13.2.Rel1-x86_64-arm-none-eabi.tar.xz \
    && tar -xf arm-gnu-toolchain-13.2.Rel1-x86_64-arm-none-eabi.tar.xz \
    && rm *.tar.xz
    
    # ENV PATH="/opt/arm-gnu-toolchain-12.3.rel1-x86_64-arm-none-eabi/bin:${PATH}"
ENV PATH="/opt/arm-gnu-toolchain-13.2.Rel1-x86_64-arm-none-eabi/bin:${PATH}"
ENV ARMGCC_DIR="/opt/arm-gnu-toolchain-12.3.rel1-x86_64-arm-none-eabi"


# Create workspace
WORKDIR /workspace

# Copy SDK and project
COPY sdk /workspace/sdk
COPY project /workspace/project
# COPY CMakeLists.txt /workspace/CMakeLists.txt
COPY build.sh /workspace/build.sh

RUN chmod +x /workspace/build.sh

# Build command executed when container runs
CMD ["/workspace/build.sh"]