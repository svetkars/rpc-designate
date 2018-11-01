.. _deploy-aio:

Deploy an AIO environment
=========================

An All-In-One (AIO) RPC environment enables you to quickly test
and preview OpenStack functionality. When you install an AIO
environment, the bind server that DNS uses as a backend
is configured on the host.
To set up an AIO RPC environment, complete
the following steps:

#. Update the host to the latest packages:

   .. code-block:: bash

      apt-get update && apt-get -y dist-upgrade && reboot

#. Add the canonical repository to your system, clone the
   required version of OpenStack (Newton in this example),
   and deploy RPC OpenStack as an AIO environment by running
   the following script:

   .. code-block:: bash

      sudo add-apt-repository ppa:canonical-kernel-team/ppa cd /opt git clone --recursive -b newton https://github.com/rcbops/rpc-openstack.git cd rpc-openstack/ export DEPLOY_AIO="yes" ./scripts/deploy.sh

#. Clone the RPC Designate repository and install designate by
   running the following script:

   .. code-block:: bash

      cd /opt git clone https://github.com/rcbops/rpc-designate.git cd rpc-designate ./scripts/deploy.sh
