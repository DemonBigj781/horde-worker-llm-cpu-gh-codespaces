# Base environment GitHub Spaces supports well
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PATH="/opt/conda/bin:$PATH"

WORKDIR /app

# Install base dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    bzip2 \
    ca-certificates \
    ffmpeg \
    libsm6 \
    libxext6 \
    && rm -rf /var/lib/apt/lists/*

# Install micromamba (used by Horde worker)
RUN curl -Ls https://micro.mamba.pm/api/micromamba/linux-64/latest \
    -o /usr/local/bin/micromamba && \
    chmod +x /usr/local/bin/micromamba

# Install AI Horde Worker (LLM/Scribe only)
RUN git clone --depth=1 https://github.com/Haidra-Org/AI-Horde-Worker.git /app

# Install scribe (text) runtime ONLY — CPU friendly
RUN cd /app && \
    chmod +x ./update-runtime.sh && \
    ./update-runtime.sh --scribe

# Ensure a default config exists
RUN cd /app && \
    if [ ! -f bridgeData.yaml ] && [ -f bridgeData_template.yaml ]; then \
        cp bridgeData_template.yaml bridgeData.yaml; \
    fi

# Runtime ENV (overridable in GitHub Space Settings → Variables)
ENV HORDE_API_KEY="" \
    HORDE_URL="https://stablehorde.net" \
    HORDE_WORKER_NAME="cpu-llm-space-worker" \
    HORDE_MAX_THREADS="2"

# Start the worker automatically
ENTRYPOINT ["/app/horde-scribe-bridge.sh"]
