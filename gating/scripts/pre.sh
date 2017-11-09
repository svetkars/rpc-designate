#!/usr/bin/env bash
# Copyright 2014-2017 , Rackspace US, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

## Shell Opts ----------------------------------------------------------------
set -xeuo pipefail

## Vars ----------------------------------------------------------------------
source ${PWD}/gating/scripts/vars.sh

## Main ----------------------------------------------------------------------
echo "Pre gate job started"
echo "+-------------------- START ENV VARS --------------------+"
env
echo "+-------------------- START ENV VARS --------------------+"

# Clone rpc-openstack
if [ ! -d ${OS_BASE_DIR} ]; then
  git clone --recursive -b ${RPC_RELEASE} https://github.com/rcbops/rpc-openstack ${OS_BASE_DIR}
fi

# Make sure that we are in the base dir and deploy openstack aio
cd ${OS_BASE_DIR}
${OS_BASE_DIR}/scripts/deploy.sh

# Install Designate
${MY_BASE_DIR}/scripts/deploy.sh

# We may need this later, right now I don't run any tempest tests
# install tempest
#cd ${OS_BASE_DIR}/openstack-ansible/playbooks/
#openstack-ansible  ${OS_BASE_DIR}/openstack-ansible/playbooks/os-tempest-install.yml

echo "Pre gate job ended"
