#!/usr/bin/env bash
# Copyright 2014-2017, Rackspace US, Inc.
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
source ${BASE_DIR}/scripts/functions.sh
export DESIGNATE_DEPLOY_OPS="-e @/opt/rpc-designate/playbooks/group_vars/designate_all.yml "

# Perform peliminary configurations for Designate
run_ansible /opt/rpc-designate/playbooks/setup-designate.yml

# ReBootstrap ansible to add the os_designate role to ansible
${BASE_DIR}/scripts/bootstrap-ansible.sh

cd /opt/rpc-openstack/openstack-ansible/playbooks/

# build container
run_ansible lxc-containers-create.yml --limit designate_all
run_ansible openstack-hosts-setup.yml --tags openstack_hosts-config

if [[ "${DEPLOY_AIO}" == "yes" ]]; then
  run_ansible /opt/rpc-designate/playbooks/setup-bind.yml
  export DESIGNATE_DEPLOY_OPS=${DESIGNATE_DEPLOY_OPS}"-e @/opt/rpc-designate/playbooks/files/aio/pools.yml.aio "
fi

# install designate
run_ansible ${DESIGNATE_DEPLOY_OPS} -e "designate_developer_mode=True" /opt/rpc-designate/playbooks/os-designate-install.yml

# add service to haproxy
run_ansible ${DESIGNATE_DEPLOY_OPS} haproxy-install.yml 

# open ports for designate-mdns
run_ansible ${DESIGNATE_DEPLOY_OPS} /opt/rpc-designate/playbooks/setup-infra-firewall-mdns.yml

# add filebeat to service so we get logging
cd /opt/rpc-openstack/
run_ansible /opt/rpc-openstack/rpcd/playbooks/filebeat.yml --limit designate_all
