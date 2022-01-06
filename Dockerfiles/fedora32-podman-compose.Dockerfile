FROM fedora:32 as fedora32-builder
ENV FEDORA_VERSION=32
RUN bash --norc --noprofile -c 'env|grep FEDORA_VERSION'
ENV ANSIBLE_VERSION=4.9.0
RUN dnf -y install binutils python3 python3-setuptools rsync findutils python3-wheel pv python3-pip python3-devel bat less patchelf glibc glibc-devel glibc-static glibc-utils
RUN python3 -m venv /root/.ansible-build-venv
RUN bash --norc --noprofile -c 'source /root/.ansible-build-venv/bin/activate && pip install -q -U pip && pip install six watchdog pyinstaller staticx'
COPY dist/upx-3.96-amd64_linux/upx /usr/bin/upx
RUN upx --version


FROM fedora32-builder as fedora32-podman-compose
RUN dnf -y install podman bash
ADD dist/podman-compose-v1.0.3.tar.gz /
WORKDIR /static
WORKDIR /compile
RUN python3 -m venv /root/.ansible-build-venv
RUN bash --norc --noprofile -c 'source /root/.ansible-build-venv/bin/activate && pip install -q -U pip && pip install pyinstaller staticx pyyaml ansible six'
RUN bash --norc --noprofile -c 'source /root/.ansible-build-venv/bin/activate && pip3 install podman-compose'
#-1.0.3'
RUN bash --norc --noprofile -c 'source /root/.ansible-build-venv/bin/activate && command -v podman-compose'
RUN bash --norc --noprofile -c 'source /root/.ansible-build-venv/bin/activate && command podman-compose --version'
COPY specs/podman-compose.spec /compile
#RUN bash --norc --noprofile -c 'source /root/.ansible-build-venv/bin/activate && pyinstaller /compile/podman-compose.spec'

#RUN bash --norc --noprofile -c 'source /root/.ansible-build-venv/bin/activate && cp $(command -v podman-compose) ./podman-compose.py'
#RUN bash --norc --noprofile -c 'source /root/.ansible-build-venv/bin/activate && pyinstaller /podman-compose-1.0.3/podman_compose.py --strip --collect-all podman_compose --clean'
#RUN rm -rf /compile/dist /compile/build
#RUN bash --norc --noprofile -c 'source /root/.ansible-build-venv/bin/activate && pyinstaller /podman-compose-1.0.3/podman_compose.py --collect-all podman_compose --strip --onedir'
#RUN ls -altR /compile
#RUN ls /compile/dist/podman_compose/podman_compose
#RUN /compile/dist/podman_compose/podman_compose --help
#RUN /compile/dist/podman_compose/podman_compose --version
#RUN cp /compile/dist/podman_compose/podman_compose /compile/dist/podman_compose/podman-compose
#RUN /compile/dist/podman_compose/podman-compose --help
#RUN /compile/dist/podman_compose/podman-compose --version
#RUN ldd /compile/dist/podman_compose/podman_compose
#RUN rm -rf /static
#WORKDIR /static
#RUN bash --norc --noprofile -c 'source /root/.ansible-build-venv/bin/activate && staticx --strip --loglevel ERROR /compile/dist/podman_compose/podman_compose /static/podman-compose'
#RUN /static/podman-compose --help
#RUN /static/podman-compose --version
#RUN ldd /static/podman-compose


