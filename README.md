# rpc-designate

This repository simplifies the installation of Designate into RPC-O or OSA.

![deployment model](doc/designate-model.png)

## Deploying 

Deploying to either and AIO or regular environment is the same process.
For more detail please refer to the [INSTALLATION](INSTALLATION.md) file included in the repository.

- Deploy OpenStack
    - This can be done in a variety of ways either using rpc-openstack or using upstream OpenStack Ansible
- Run the deployment script 
## Setup an AIO

Update the host to the latest packages

apt-get update && apt-get -y dist-upgrade && reboot

## Install RPC-O as an AIO

When installing in an AIO environment, a bind server will be configured on the host.

sudo add-apt-repository ppa:canonical-kernel-team/ppa cd /opt git clone --recursive -b newton https://github.com/rcbops/rpc-openstack.git cd rpc-openstack/ export DEPLOY_AIO="yes" ./scripts/deploy.sh

Install Designate

cd /opt git clone https://github.com/rcbops/rpc-designate.git cd rpc-designate ./scripts/deploy.sh


