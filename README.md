# rpc-designate

This integrated Newton Designate with Newton RPC-O.

In the future this repo might include script to update/remove things once RPC-O Ocata is ready.

To use this role you will need to follow the documentation for configuring the service and the required pools 

## TODO: Additional Documentation around configuring the role

## Setup an AIO

Update the host to the latest packages

apt-get update && apt-get -y dist-upgrade && reboot

## Install RPC-O as an AIO

When installing in an AIO environemnt a bind server will be configured on the host.

sudo add-apt-repository ppa:canonical-kernel-team/ppa cd /opt git clone --recursive -b newton https://github.com/rcbops/rpc-openstack.git cd rpc-openstack/ export DEPLOY_AIO="yes" ./scripts/deploy.sh

Install Designate

cd /opt git clone https://github.com/rcbops/rpc-designate.git cd rpc-designate ./scripts/deploy.sh

