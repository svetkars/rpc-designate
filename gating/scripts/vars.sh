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

# The scripts expects the git clone to be at /opt/rpc-designate, so we link
# the current folder there.

if [[ "${PWD}" != "/opt/rpc-designate" ]]; then
  ln -sfn ${PWD} /opt/rpc-designate
fi

# Use and AIO for gate testing
export DEPLOY_AIO="yes"

# rpc-openstack base directory
export OS_BASE_DIR=/opt/rpc-openstack

# The MY_BASE_DIR needs to be set to ensure that the scripts
# know it and use this checkout appropriately.
export MY_BASE_DIR=/opt/rpc-designate/

# We want the role downloads to be done via git
export ANSIBLE_ROLE_FETCH_MODE="git-clone"

# To provide flexibility in the jobs, we have the ability to set any
# parameters that will be supplied on the ansible-playbook CLI.
export ANSIBLE_PARAMETERS=${ANSIBLE_PARAMETERS:--v}

# If RE_JOB_SCENARIO is set to functional, we need to change it to newton
if [ ${RE_JOB_SCENARIO} == 'functional' ]; then
  export RE_JOB_SCENARIO="newton"
fi

# Pin the newton version of rpc-openstack
export RPC_NEWTON_RELEASE="r14.3.0"

# Pin the pike version of rpc-openstack
export RPC_PIKE_RELEASE="r16.0.0"