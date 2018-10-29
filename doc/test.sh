#!/bin/sh

set -e
echo "enable git new"
source /opt/rh/rh-git29/enable
git branch -vv
source /opt/rh/python27/enable
virtualenv jenkinstox2
source jenkinstox2/bin/activate
cd docs/
pip install --upgrade pip
pip --version
pip install tox
tox -e checksyntax
tox -e checkbuild
tox -e checkspelling
