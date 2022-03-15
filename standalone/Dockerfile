ARG PARENT_IMAGE=openmicroscopy/omero-web:latest
ARG LOCATION=./standalone/
FROM ${PARENT_IMAGE}
MAINTAINER ome-devel@lists.openmicroscopy.org.uk

USER root

RUN /opt/omero/web/venv3/bin/pip install \
        'django-cors-headers<3.3' \
        omero-figure \
        omero-iviewer \
        omero-fpbioimage \
        omero-mapr \
        omero-parade \
        omero-webtagging-autotag \
        omero-webtagging-tagsearch \
        whitenoise

ADD ${LOCATION}01-default-webapps.omero /opt/omero/web/config/

USER omero-web
