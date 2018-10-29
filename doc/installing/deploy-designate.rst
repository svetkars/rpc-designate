.. _deploy-designate:

Deploy designate
================

After you complete the steps described in
:ref:`prepare-installation` and
:ref:`configure-dns-server-pool`, you can deploy designate on your
RPCO or RPCR environment.

Deploy RPC designate by running the
``scripts/deploy.sh`` script that is stored in this repository.
The deploy script performs the following actions:

- Detects the version of OpenStack.
- Creates containers for the Berkeley Internet Name Domain (BIND)
  9 backend and for designate on all infrastructure nodes.
- Deploys BIND 9 and configures it to work with designate.
- Creates a pool configuration at ``/etc/openstack_deploy/designate_pools.yml``
  to set up designate to work with the installed BIND 9 software.
- Deploy designate by using the default configuration.
- Configure the firewall on the infrastructure hosts to enable
  communication from infrastructure nodes IP addresses to BIND 9.

To deploy designate, run the following script:

.. code-block:: bash

   scripts/deploy.sh
