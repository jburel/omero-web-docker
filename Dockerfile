FROM rockylinux:9
LABEL maintainer="ome-devel@lists.openmicroscopy.org.uk"


RUN mkdir /opt/setup
WORKDIR /opt/setup
ADD playbook.yml requirements.yml /opt/setup/

RUN dnf -y install epel-release
RUN dnf install -y glibc-langpack-en
ENV LANG en_US.utf-8

RUN dnf install -y python3.12 python3.12-pip

# Make Python 3.12 the default
RUN alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 1
RUN alternatives --install /usr/bin/pip pip /usr/bin/pip3.12 1

RUN python3 --version
RUN pip --version

RUN dnf install -y git

RUN pip install ansible-core
RUN dnf -y install sudo
RUN ansible-galaxy collection install ansible.posix
RUN ansible-galaxy collection install community.general

RUN ansible-galaxy install -p /opt/setup/roles -r requirements.yml \
    && dnf -y clean all \
    && rm -fr /var/cache

RUN ansible-playbook playbook.yml -e 'ansible_python_interpreter=/usr/bin/python3' \
    && dnf -y clean all \
    && rm -fr /var/cache


RUN curl -L -o /usr/local/bin/dumb-init \
    https://github.com/Yelp/dumb-init/releases/download/v1.2.5/dumb-init_1.2.5_x86_64 && \
    chmod +x /usr/local/bin/dumb-init
ADD entrypoint.sh /usr/local/bin/
ADD 50-config.py 60-default-web-config.sh 98-cleanprevious.sh 99-run.sh /startup/
ADD ice.config /opt/omero/web/OMERO.web/etc/

USER omero-web
EXPOSE 4080
VOLUME ["/opt/omero/web/OMERO.web/var"]

ENV OMERODIR=/opt/omero/web/OMERO.web/
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
