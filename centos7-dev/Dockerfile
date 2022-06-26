FROM centos:centos7.9.2009

# install dependencies
RUN cd /etc/yum.repos.d/ && curl -O https://copr.fedorainfracloud.org/coprs/vbatts/bazel/repo/epel-7/vbatts-bazel-epel-7.repo 
RUN yum -y update && yum -y install gcc \
	which \
    zip \
    unzip \
    git \
    zlib-devel \
    make \
    cmake \
    gdb \
    gcc-c++ \
    openssl \
    openssh-server \
    bazel4 && yum clean all -y

RUN mkdir -p /home/work/mbase /var/run/sshd /root/.ssh/
RUN echo root:password | chpasswd
RUN ssh-keygen -q -t rsa -b 2048 -f /etc/ssh/ssh_host_rsa_key -N '' -P ''
RUN ssh-keygen -q -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N ''
#RUN ssh-keygen -t dsa -f /etc/ssh/ssh_host_ed25519_key  -N ''
RUN sed -i "s/#UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config
RUN sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
WORKDIR /home/work
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
