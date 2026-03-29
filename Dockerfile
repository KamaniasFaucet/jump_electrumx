FROM python:3.10-slim

RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    libleveldb-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip install --no-cache-dir \
    aiorpcX>=0.23.0 \
    attrs \
    plyvel \
    aiohttp

WORKDIR /opt
COPY . /opt/jump_electrumx

WORKDIR /opt/jump_electrumx

# Install ElectrumX
RUN pip install -e . && \
    chmod +x electrumx_server electrumx_rpc electrumx_compact_history

EXPOSE 50001 50002

ENV COIN=Jumpcoin
ENV NET=mainnet
ENV DB_DIRECTORY=/data
ENV SERVICES=tcp://0.0.0.0:50001,ssl://0.0.0.0:50002
ENV ALLOW_ROOT=true

VOLUME /data

CMD ["/opt/jump_electrumx/electrumx_server"]