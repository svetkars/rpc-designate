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

set -e -u -x
set -o pipefail

export BASE_DIR=${BASE_DIR:-"/opt/rpc-openstack"}
export MY_BASE_DIR=${MY_BASE_DIR:-"/opt/rpc-designate"}
export DESIGNATE_DEPLOY_OPS="-e @/opt/rpc-designate/playbooks/group_vars/designate_all.yml "

source ${BASE_DIR}/scripts/functions.sh
source ${MY_BASE_DIR}/scripts/functions.sh

# We need to determine the product release if this is not already set  
if [[ -z ${RPC_PRODUCT_RELEASE+x} ]]; then
  determine_release
fi

# Perform peliminary configurations for Designate
setup_designate 
deploy_container
# If we are running and AIO, deploy the local name server
if [[ "${DEPLOY_AIO}" == "yes" ]]; then
  deploy_bind
fi

# Install Designate
deploy_designate

# add service to haproxy
openstack-ansible ${DESIGNATE_DEPLOY_OPS} haproxy-install.yml

# install rndc key to designate containers
openstack-ansible ${DESIGNATE_DEPLOY_OPS} /opt/rpc-designate/playbooks/install_rndc_key.yml

# open ports for designate-mdns
openstack-ansible ${DESIGNATE_DEPLOY_OPS} /opt/rpc-designate/playbooks/setup-infra-firewall-mdns.yml
