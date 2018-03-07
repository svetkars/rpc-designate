#!/usr/bin/env bash
# Copyright 2014-2018, Rackspace US, Inc.
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

## Vars and Functions --------------------------------------------------------
source ${PWD}/gating/scripts/vars.sh
source ${PWD}/gating/scripts/functions.sh

## Main ----------------------------------------------------------------------
echo "Pre gate job started"
echo "+-------------------- START ENV VARS --------------------+"
env
echo "+-------------------- START ENV VARS --------------------+"

# If we're not using a pre-saved rpc-openstack image, then deploy the
# necessary OpenStack infrastructure and services.
if [[ ! ${RE_JOB_IMAGE} =~ _snapshot$ ]]; then

  case $RE_JOB_SCENARIO in
  "newton")
    # Pin RPC-Release to 14.3 for newton
    export RPC_RELEASE="r14.3.0"
    export RPC_PRODUCT_RELEASE=${RE_JOB_SCENARIO}
    export OSA_BASE_DIR=${OS_BASE_DIR}/openstack-ansible
    clone_openstack
    gate_deploy_newton
  ;;
  "pike")
    export RPC_RELEASE="r16.0.0"
    export RPC_PRODUCT_RELEASE=${RE_JOB_SCENARIO}
    export OSA_BASE_DIR=${OS_BASE_DIR}/openstack-ansible
    clone_openstack
    gate_deploy_pike
  ;;
  esac
  
fi

# Install Designate
cd ${MY_BASE_DIR}
${MY_BASE_DIR}/scripts/deploy.sh

# We may need this later, right now I don't run any tempest tests
# install tempest
#cd ${OS_BASE_DIR}/openstack-ansible/playbooks/
#openstack-ansible  ${OS_BASE_DIR}/openstack-ansible/playbooks/os-tempest-install.yml

echo "Pre gate job ended"
