#!/bin/bash
# Original: github.com/broadinstitute/viral-ngs

set -e

MINICONDA_VERSION=4.3.11

# the miniconda directory may exist if it has been restored from cache
if [ -d "$MINICONDA_DIR" ] && [ -e "$MINICONDA_DIR/bin/conda" ]; then
  echo "Miniconda install already present from cache: $MINICONDA_DIR"
  export PATH="$MINICONDA_DIR/bin:$PATH"
else # if it does not exist, we need to install miniconda
  rm -rf "$MINICONDA_DIR" # remove the directory in case we have an empty cached directory

  if [[ "$TRAVIS_PYTHON_VERSION" == 2* ]]; then
      wget https://repo.continuum.io/miniconda/Miniconda2-$MINICONDA_VERSION-Linux-x86_64.sh -O miniconda.sh;
  else
      wget https://repo.continuum.io/miniconda/Miniconda3-$MINICONDA_VERSION-latest-Linux-x86_64.sh -O miniconda.sh;
  fi

  bash miniconda.sh -b -p "$MINICONDA_DIR"
  chown -R "$USER" "$MINICONDA_DIR"

  export PATH="$MINICONDA_DIR/bin:$PATH"
  hash -r

  conda config --set always_yes yes --set changeps1 no
  conda update -q conda
  conda info -a # for debugging
fi
