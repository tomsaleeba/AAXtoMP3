FROM ubuntu:22.10

RUN \
  apt update && \
  apt install --no-install-recommends --assume-yes \
    ffmpeg \
    mediainfo \
    bc \
  && \
  rm -fr /var/lib/apt/lists/
RUN mkdir /target && \
  touch /target/MOUNT_A_VOLUME_OVER_THIS_DIR
WORKDIR /app
ADD AAXtoMP3 LICENSE README.md  docker-entrypoint.sh ./
ENTRYPOINT ["bash", "docker-entrypoint.sh"]
