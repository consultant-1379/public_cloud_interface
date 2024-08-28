FROM centos

COPY client-machine-provisioning /tmp/
ADD terraform_wrapper_packaged.tar.gz /tmp/
COPY /terraform-templates/ /input/ /root/terraform-templates/

WORKDIR /tmp/client-machine-setup

RUN yum update -y \
    && yum install -y epel-release \
    && yum install -y jq \
    && yum groupinstall -y "development tools" \
    && yum install -y https://centos7.iuscommunity.org/ius-release.rpm  \
    && yum update -y \
    && yum install -y python36u python36u-libs python36u-devel python36u-pip \
    && ln -s /usr/bin/python3.6 /usr/bin/python3 \
    && ln -s /usr/bin/pip3.6 /usr/bin/pip3 \
    && pip3 install --upgrade pip \
    && yum install -y ansible initscripts openssh-server \
    && sed -i 's/.*PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/.*#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config \
    && ansible-playbook basic-setup.yaml -i hosts/staging --connection=local \
    && rm -rfv /tmp/*.zip /tmp/terraform /tmp/aws_cli /tmp/client-machine-setup \
    && rm -rfv /var/cache/yum \
    && rm -rfv ~/.cache/pip

WORKDIR /tmp

RUN export VERSION=$(ls packages | grep terraform_wrapper | cut -d"_" -f3 | cut -d"-" -f2) \
    && echo "wrapper version: $VERSION" \
    && pip3 install packages/terraform_wrapper_cli-$VERSION-py2.py3-none-any.whl --no-index --find-links=packages \
    && rm -rfv /tmp/packages ~/.cache/pip \
    && mkdir -p ~/.kube

WORKDIR /root/terraform-templates

RUN terraform_wrapper --operation init --input_file input.json
