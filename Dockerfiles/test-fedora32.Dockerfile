FROM fedora:32 as test-fedora32
RUN yum -y install dnf
RUN dnf -y install findutils
WORKDIR /binaries
ADD binaries/* /binaries/
RUN find /binaries -type f
RUN /binaries/ansible-playbook --version
