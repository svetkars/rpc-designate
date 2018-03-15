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

# openstack-ansible base dir
if [ -d "/opt/openstack-ansible" ]; then
    export OSA_BASE_DIR=/opt/openstack-ansible
else
    export OSA_BASE_DIR=${BASE_DIR}/openstack-ansible
fi

function deploy_bind {
    openstack-ansible ${MY_BASE_DIR}/playbooks/setup-bind.yml
    # export DESIGNATE_DEPLOY_OPS=${DESIGNATE_DEPLOY_OPS}"-e @/opt/rpc-designate/playbooks/files/aio/pools.yml.aio "
}

function deploy_designate {
    if [[ ${RPC_PRODUCT_RELEASE} == 'newton' ]]; then
        openstack-ansible ${DESIGNATE_DEPLOY_OPS} -e "designate_developer_mode=True" /opt/rpc-designate/playbooks/os-designate-install.yml
    elif [[ ${RPC_PRODUCT_RELEASE} == 'pike' ]]; then
        openstack-ansible ${DESIGNATE_DEPLOY_OPS} /opt/openstack-ansible/playbooks/os-designate-install.yml
    fi
}

function deploy_container {
    # build container
    cd ${OSA_BASE_DIR}/playbooks
    openstack-ansible lxc-containers-create.yml --limit hosts:designate_all:designate_bind_all
    openstack-ansible openstack-hosts-setup.yml --tags openstack_hosts-config
    if [[ ${RPC_PRODUCT_RELEASE} == 'pike' ]]; then
        openstack-ansible repo-build.yml
    fi
}


function determine_release { 
    if [[ -z $RPC_RELEASE ]]; then
        echo "Unable to determine rpc release"
        exit
    else
        # For now setting to newton if RPC_PRODUCT_RELEASE is not set
        export RPC_PRODUCT_RELEASE="newton"
    fi
}


function setup_designate {
    openstack-ansible /opt/rpc-designate/playbooks/setup-designate.yml
    # If we are running this on newton, we added a role to the requirements
    # so we need to re bootstrap ansible to add the role. In pike this should 
    # already exist
    if [[ ${RPC_PRODUCT_RELEASE} == 'newton' ]]; then
        ${BASE_DIR}/scripts/bootstrap-ansible.sh
    fi
    # Once this has run we can add the designate pools YAML to the includes
    # so we have the pool information
    if [ -f "/etc/openstack_deploy/designate_pools.yml" ]; then
        export DESIGNATE_DEPLOY_OPS="${DESIGNATE_DEPLOY_OPS} -e @/etc/openstack_deploy/designate_pools.yml "
    fi
}