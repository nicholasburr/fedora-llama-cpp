# Global Arguments
ARG ROCM_VERSION=7.2.1
ARG REPO=https://github.com/ggml-org/llama.cpp.git
ARG BRANCH=master
ARG GPU_TARGET=gfx1151

# --- BUILDER STAGE ---
FROM registry.fedoraproject.org/fedora:43 AS builder
ARG ROCM_VERSION
ARG REPO
ARG BRANCH
ARG GPU_TARGET

ENV ROCM_PATH=/opt/rocm \
  HIP_PATH=/opt/rocm \
  HIP_CLANG_PATH=/opt/rocm/llvm/bin \
  HIP_DEVICE_LIB_PATH=/opt/rocm/amdgcn/bitcode \
  PATH=/opt/rocm/bin:/opt/rocm/llvm/bin:$PATH

# Setup ROCm Repository
RUN printf "[ROCm-%s]\nname=ROCm-%s\nbaseurl=https://repo.radeon.com/rocm/rhel10/%s/main\nenabled=1\npriority=50\ngpgcheck=1\ngpgkey=https://repo.radeon.com/rocm/rocm.gpg.key" \
    "$ROCM_VERSION" "$ROCM_VERSION" "$ROCM_VERSION" > /etc/yum.repos.d/rocm.repo

# Install Build Dependencies 
RUN dnf -y --nodocs --setopt=install_weak_deps=False \
    --exclude='*sdk*' --exclude='*samples*' --exclude='*-doc*' --exclude='*-docs*' \
    install \
    make gcc cmake lld clang clang-devel compiler-rt libcurl-devel ninja-build \
    rocm-llvm rocm-device-libs hip-runtime-amd hip-devel \
    rocblas-devel hipblas-devel rocsolver-devel rocsparse-devel \
    rocm-cmake libomp-devel libomp git-core patch && dnf clean all

# Clone and Build llama.cpp
WORKDIR /opt/llama.cpp
RUN git clone -b ${BRANCH} --single-branch --recursive ${REPO} .
COPY files/llama.cpp-20867.patch /tmp/llama.cpp-20867.patch

# build
RUN patch -p1 < /tmp/llama.cpp-20867.patch \
    && cmake -S . -B build \
    -DGGML_HIP=ON \
    -DCMAKE_HIP_FLAGS="--rocm-path=/opt/rocm -mllvm --amdgpu-unroll-threshold-local=600" \
    -DAMDGPU_TARGETS=gfx1151 \
    -DCMAKE_BUILD_TYPE=Release \
    -DGGML_RPC=ON \
    -DLLAMA_HIP_UMA=ON \
    -DGGML_CUDA_ENABLE_UNIFIED_MEMORY=ON \
    -DROCM_PATH=/opt/rocm \
    -DHIP_PATH=/opt/rocm \
    -DHIP_PLATFORM=amd \
    && cmake --build build --config Release -- -j$(nproc) \
    && cmake --install build --config Release

# libs
RUN find /opt/llama.cpp/build -type f -name 'lib*.so*' -exec cp {} /usr/lib64/ \; \
  && ldconfig

# --- RUNTIME STAGE ---
FROM registry.fedoraproject.org/fedora-minimal:43

# Minimal runtime dependencies
RUN microdnf -y install bash ca-certificates libstdc++ libgomp procps-ng && \
    microdnf clean all

# Copy artifacts from builder
COPY --from=builder /usr/local/ /usr/local/
COPY --from=builder /opt/render-libs/ /usr/local/lib64/

# Linker Configuration
RUN echo "/usr/local/lib" > /etc/ld.so.conf.d/llama.conf && \
    echo "/usr/local/lib64" >> /etc/ld.so.conf.d/llama.conf && \
    ldconfig

# Environment Persistence
ENV PATH=/usr/local/bin:$PATH \
    LD_LIBRARY_PATH=/usr/local/lib64:/usr/local/lib:$LD_LIBRARY_PATH \
    HIP_VISIBLE_DEVICES=0 \
    GGML_HIP_UMA=1

RUN printf 'export PATH=/usr/local/bin:$PATH\nexport LD_LIBRARY_PATH=/usr/local/lib64:/usr/local/lib:$LD_LIBRARY_PATH\n' > /etc/profile.d/llama.sh && \
    chmod +x /etc/profile.d/llama.sh && \
    echo 'source /etc/profile.d/llama.sh' >> /etc/bashrc

WORKDIR /models
CMD ["/bin/bash"]
