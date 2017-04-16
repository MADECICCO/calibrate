.PHONY: image \
	clean clean-pyc clean-build clean-js \
	test \
	bump/major bump/minor bump/patch \
	start \
	release
SHELL = /bin/bash
.SHELLFLAGS = -c

CALIBRATE_HOME ?= /usr/src/calibrate

CONDA = source activate calibrate;
SETUP = ${CONDA} python setup.py

all: test-tox


clean: clean-build clean-pyc clean-js

clean-build:
	rm -rf build/
	rm -rf dist/
	rm -rf *.egg-info

clean-pyc:
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +

test:
	${SETUP} nosetests

bump/major bump/minor bump/patch:
	${CONDA} bumpversion --verbose $(@F)

MAKE_EXT = docker-compose run --rm calibrate make -C ${CALIBRATE_HOME}

# Generically execute make targets from outside the Docker container
%-ext: image
	${MAKE_EXT} $*

# Build the image
image:
	GIT_USER_NAME=`git config user.name` GIT_USER_EMAIL=`git config user.email` docker-compose build --pull
