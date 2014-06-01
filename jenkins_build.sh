#!/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# setup python
if [ ! -d env ]
then
  virtualenv env
fi
. env/bin/activate
./env/bin/pip install -r requirements.txt

export PYTHONPATH=$PYTHONPATH:$DIR
export PATH=$PATH:$DIR/bin

# setup node
if [ -n "$BARRISTER_NODE" ]
then
  # force module to reinstall
  rm -rf node_modules
  npm install $BARRISTER_NODE
fi

# run tests
./run_tests.sh

# generate docs
rm -rf doc
epydoc -q --parse-only -o doc --docformat=restructuredText --exclude=test barrister
