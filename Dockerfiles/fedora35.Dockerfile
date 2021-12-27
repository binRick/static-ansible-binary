FROM fedora:35 as fedora35-builder
ENV ANSIBLE_VERSION=4.9.0
RUN dnf -y install binutils python3 python3-setuptools rsync findutils python3-wheel pv python3-pip python3-devel bat less patchelf glibc glibc-devel glibc-static glibc-utils
ADD dist/ansible-4.9.0.tar.gz /

RUN python3 -m venv /root/.ansible-build-venv
RUN bash --norc --noprofile -c 'source /root/.ansible-build-venv/bin/activate && pip install -q -U pip && pip install six watchdog /ansible-4.9.0 pyinstaller staticx'

WORKDIR /compile

RUN bash --norc --noprofile -c 'source /root/.ansible-build-venv/bin/activate && cp $(command -v ansible-playbook) /compile/ansible-playbook.py'

COPY specs/ansible.spec /compile
RUN bash --norc --noprofile -c 'source /root/.ansible-build-venv/bin/activate && pyinstaller /compile/ansible.spec'

#RUN bash --norc --noprofile -c 'source /root/.ansible-build-venv/bin/activate && pip install /staticx'
#RUN bash -c 'source /root/.ansible-build-venv/bin/activate && pip install /ansible-4.9.0'
#RUN bash -c 'source /root/.ansible-build-venv/bin/activate && pyinstaller ansible.spec'
#RUN bash -c 'python3 -m pip install staticx && find /compile/dist -type f | while read -r f; do staticx --strip --loglevel $LOG_LEVEL /compile/dist/$(basename $f) /compile/dist-static/$(basename $f); done'
#RUN bash -c 'find /compile/dist /compile/dist-static -type f > /files.txt'

#RUN bash -c 'source /root/.ansible-build-venv/bin/activate && pip install -q -U pip && pip install six pyinstaller staticx -q'
#
#WORKDIR /compile
#COPY bin/passh ansi bin/staticx /compile/
#
#RUN python3 -m pip install staticx
