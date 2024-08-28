FROM armdocker.rnd.ericsson.se/proj-nmaas-pub/prod/cm_provisioning:latest

ARG VERSION

ADD terraform_wrapper_packaged.tar.gz /tmp/

WORKDIR /tmp

RUN pip3 install packages/terraform_wrapper_cli-${VERSION}-py2.py3-none-any.whl --no-index --find-links=packages \
    && rm -rfv /tmp/packages ~/.cache/pip \
    && mkdir -p ~/.kube

COPY /terraform-templates/ /input/ /root/terraform-templates/

WORKDIR /root/terraform-templates

RUN terraform_wrapper --operation init --input_file input.json
