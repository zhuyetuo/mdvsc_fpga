FROM xilinx/vitis-ai-pytorch-cpu:latest

ENV DEBIAN_FRONTEND=noninteractive

# 你自己的额外工具
RUN apt-get update && apt-get install -y \
    vim tree git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace
CMD ["/bin/bash"]