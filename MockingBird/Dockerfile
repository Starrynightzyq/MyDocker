FROM ubuntu-xorg

RUN \
    apt update && \
    apt upgrade -y && \
    apt -y --no-install-recommends install \
        ffmpeg \
        git \
        liblzma-dev \
        build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev wget libbz2-dev && \
    apt-get autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*

COPY MockingBird /mnt/MockingBird
COPY my_run.pt /mnt/MockingBird/vocoder/saved_models/pretrained/

RUN apt-get purge -y python.*
ENV LANG C.UTF-8

RUN \
    cd /root && \
    wget https://npm.taobao.org/mirrors/python/3.9.2/Python-3.9.2.tgz && \
    tar -xzvf Python-3.9.2.tgz && \
    cd Python-3.9.2 && \
    mkdir /usr/python3 && \
    ./configure --enable-optimizations --prefix=/usr/python3 && \
    make -j && \
    make install

RUN \
    export PATH=/usr/python3/bin:${PATH} > /root/.bashrc
ENV PATH="/usr/python3/bin:${PATH}"

RUN \
    update-alternatives --install /usr/bin/python3 python3 /usr/python3/bin/python3.9 1 && \
    update-alternatives --install /usr/bin/pip3 pip3 /usr/python3/bin/pip3.9 1

RUN \
    cd /usr/bin && \
    ln -s python3 python && \
    ln -s pip3 pip

RUN \
    python -m pip install --no-cache-dir -i https://pypi.tuna.tsinghua.edu.cn/simple --upgrade pip

RUN /bin/bash -c \
    'pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple'

RUN \
    cd /root && \
    rm -rf Python-3.9.2 && \
    rm -rf Python-3.9.2.tgz && \
    apt remove -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev wget libbz2-dev && \
    apt autoremove -y

RUN \
    apt update && \
    apt -y --no-install-recommends install \
        gcc \
        gcc-multilib && \
    apt-get autoclean -y && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

RUN \
    cd /mnt/MockingBird && \
    pip install -r requirements.txt && \
    pip install webrtcvad-wheels

RUN \
    pip install torch==1.9.1 torchvision==0.10.1 torchaudio==0.9.1 -i https://pypi.tuna.tsinghua.edu.cn/simple

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["/bin/bash", "-l"]
