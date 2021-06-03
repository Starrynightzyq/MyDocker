FROM ubuntu-xorg

RUN \
  dpkg --add-architecture i386 && \
  apt update && \
  apt -y --no-install-recommends install \
    build-essential git gcc-multilib libc6-dev:i386 ocl-icd-opencl-dev libjpeg62-dev && \
  apt-get install -y vim && \
  apt-get autoclean && \
  apt-get autoremove && \
  rm -rf /var/lib/apt/lists/*

COPY install_config.txt /vivado-installer/
COPY Vivado_license_to2037.lic /vivado-installer/

ARG VIVADO_TAR_URI=http://host.docker.internal/Xilinx_Unified_2020.2_1118_1232.tar.gz
RUN \
  curl ${VIVADO_TAR_URI} | tar zx --strip-components=1 -C /vivado-installer && \
  /vivado-installer/xsetup \
    --agree 3rdPartyEULA,WebTalkTerms,XilinxEULA \
    --batch Install \
    --config /vivado-installer/install_config.txt && \
  echo "source /opt/Xilinx/Vivado/2020.2/.settings64-Vivado.sh" >> /etc/bash.bashrc && \
  mkdir -p /work/.Xilinx && \
  cp /vivado-installer/Vivado_license_to2037.lic /work/.Xilinx/Vivado_license_to2037.lic && \
  rm -rf /vivado-installer

ADD pynq-z2.tar.gz /opt/Xilinx/Vivado/2020.2/data/boards/board_files/

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["/bin/bash", "-l"]
