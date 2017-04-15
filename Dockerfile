# Development Dockerfile to make testing easier under a standardized environment.
# XXX Do not use for production as-is

FROM python:2.7
LABEL maintainer Ginkgo Bioworks <devs@ginkgobioworks.com>

ARG GIT_USER_NAME="Calibrate Default"
ARG GIT_USER_EMAIL="devs@ginkgobioworks.com"

RUN git config --global user.name "$GIT_USER_NAME" \
    && git config --global user.email "$GIT_USER_EMAIL"

ARG DEBIAN_FRONTEND=noninteractive
ENV CALIBRATE_HOME=/usr/src/calibrate

RUN mkdir -p $CALIBRATE_HOME
WORKDIR $CALIBRATE_HOME

COPY requirements.txt ./
RUN pip install --requirement requirements.txt

COPY . ./
RUN pip install --editable .
CMD ["make", "test"]
