FROM fedora:35 as fedora35-builder
ENV ANSIBLE_VERSION=4.9.0
RUN dnf -y install binutils python3 python3-setuptools rsync findutils python3-wheel pv python3-pip python3-devel bat less patchelf glibc glibc-devel glibc-static glibc-utils
ADD dist/ansible-4.9.0.tar.gz /

RUN python3 -m venv /root/.ansible-build-venv
RUN bash --norc --noprofile -c 'source /root/.ansible-build-venv/bin/activate && pip install -q -U pip && pip install six watchdog /ansible-4.9.0 pyinstaller staticx'

WORKDIR /compile

RUN bash --norc --noprofile -c 'source /root/.ansible-build-venv/bin/activate && cp $(command -v ansible-playbook) /compile/ansible-playbook.py'

COPY specs/ansible-playbook.spec /compile
COPY specs/ansible.spec /compile
RUN bash --norc --noprofile -c 'source /root/.ansible-build-venv/bin/activate && pyinstaller /compile/ansible-playbook.spec'
WORKDIR /static


RUN bash --norc --noprofile -c 'source /root/.ansible-build-venv/bin/activate && staticx --strip --loglevel ERROR /compile/dist/ansible-playbook /static/ansible-playbook'

RUN /static/ansible-playbook --help
RUN /static/ansible-playbook --version

#RUN ldd /compile/dist/*
#RUN ldd /static/*||true
