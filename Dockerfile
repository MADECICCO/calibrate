# Development Dockerfile to make testing easier under a standardized environment.
# XXX Do not use for production as-is

FROM continuumio/miniconda:4.3.11
LABEL maintainer Ginkgo Bioworks <devs@ginkgobioworks.com>

# Needed to source anaconda environment
SHELL ["bash", "-c"]

ARG GIT_USER_NAME="Calibrate Default"
ARG GIT_USER_EMAIL="devs@ginkgobioworks.com"

RUN git config --global user.name "$GIT_USER_NAME" \
    && git config --global user.email "$GIT_USER_EMAIL"

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get install --yes make

ENV PYTHON_VERSION=2.7

COPY environment.yml ./
RUN conda create --verbose --yes --name=calibrate python=$PYTHON_VERSION \
    && conda env update --verbose --name=calibrate --file=environment.yml

ENV CALIBRATE_HOME=/usr/src/calibrate
RUN mkdir -p $CALIBRATE_HOME
WORKDIR $CALIBRATE_HOME

COPY . ./

RUN source activate calibrate \
    && python setup.py develop

CMD ["make", "test"]
