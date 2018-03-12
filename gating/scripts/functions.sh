#!/usr/bin/env bash
# Copyright 2014-2018 , Rackspace US, Inc.
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

clone_openstack() {
  if [ ! -d ${OS_BASE_DIR} ]; then
    git clone --recursive -b ${RPC_RELEASE} https://github.com/rcbops/rpc-openstack ${OS_BASE_DIR}
  fi
}

gate_deploy_pike() {
  # for now we are just going to deploy using the deployment script
  cd ${OS_BASE_DIR}
  scripts/deploy.sh
}

gate_deploy_newton() {
  # fixup a couple packages for keystone compatibility
  echo "python-ldap==2.5.2" >> ${OSA_BASE_DIR}/global-requirement-pins.txt
  echo "Flask!=0.11,<1.0,>=0.10" >> ${OSA_BASE_DIR}/global-requirement-pins.txt
  
  # Make sure that we are in the base dir and deploy openstack aio
  cd ${OS_BASE_DIR}
  
  # Setup ansible for the environment
  scripts/bootstrap-ansible.sh

  # Setup the aio environment
  scripts/bootstrap-aio.sh

  cd ${OS_BASE_DIR}/openstack-ansible
  # Configure Host for openstack
  openstack-ansible playbooks/setup-hosts.yml

  # Configure Infrastructure for Openstack
  openstack-ansible playbooks/setup-infrastructure.yml

  # Keystone is the only openstack service that we need installed
  openstack-ansible playbooks/os-keystone-install.yml
}