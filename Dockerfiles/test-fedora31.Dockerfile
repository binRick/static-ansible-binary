FROM fedora:31 as test-fedora31
RUN yum -y install dnf
RUN dnf -y install findutils
WORKDIR /binaries
ADD binaries/* /binaries/
RUN find /binaries -type f
RUN /binaries/ansible-playbook --version
