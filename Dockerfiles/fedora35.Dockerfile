FROM fedora:35 as fedora35-builder
ENV FEDORA_VERSION=35
RUN bash --norc --noprofile -c 'env|grep FEDORA_VERSION'
ENV ANSIBLE_VERSION=4.9.0
RUN dnf -y install binutils python3 python3-setuptools rsync findutils python3-wheel pv python3-pip python3-devel bat less patchelf glibc glibc-devel glibc-static glibc-utils
RUN python3 -m venv /root/.ansible-build-venv
RUN bash --norc --noprofile -c 'source /root/.ansible-build-venv/bin/activate && pip install -q -U pip && pip install six watchdog pyinstaller staticx'
COPY dist/upx-3.96-amd64_linux/upx /usr/bin/upx
RUN upx --version

FROM fedora35-builder as fedora35-ansible-playbook
WORKDIR /compile
ADD dist/ansible-4.9.0.tar.gz /
RUN bash --norc --noprofile -c 'source /root/.ansible-build-venv/bin/activate && pip install -q -U pip && pip install /ansible-4.9.0'
RUN bash --norc --noprofile -c 'source /root/.ansible-build-venv/bin/activate && cp $(command -v ansible-playbook) /compile/ansible-playbook.py'
COPY specs/ansible-playbook.spec /compile
RUN bash --norc --noprofile -c 'source /root/.ansible-build-venv/bin/activate && pyinstaller /compile/ansible-playbook.spec'
WORKDIR /static
RUN bash --norc --noprofile -c 'source /root/.ansible-build-venv/bin/activate && staticx --strip --loglevel ERROR /compile/dist/ansible-playbook /static/ansible-playbook'
RUN /static/ansible-playbook --help
RUN /static/ansible-playbook --version


FROM fedora35-builder as fedora35-ansible-runner

ADD dist/ansible-runner-2.1.1.tar.gz /
WORKDIR /compile
RUN bash --norc --noprofile -c 'source /root/.ansible-build-venv/bin/activate && pip install ansible-runner'
RUN bash --norc --noprofile -c 'source /root/.ansible-build-venv/bin/activate && pip install python-daemon pexpect ptyprocess six pyyaml'
RUN bash --norc --noprofile -c 'source /root/.ansible-build-venv/bin/activate && cp $(command -v ansible-runner) /compile/ansible-runner.py'
COPY specs/ansible-runner.spec /compile
RUN bash --norc --noprofile -c 'source /root/.ansible-build-venv/bin/activate && pyinstaller /compile/ansible-runner.spec'
WORKDIR /static
RUN bash --norc --noprofile -c 'source /root/.ansible-build-venv/bin/activate && staticx --strip --loglevel ERROR /compile/dist/ansible-runner /static/ansible-runner'
RUN /static/ansible-runner --help
RUN /static/ansible-runner --version
