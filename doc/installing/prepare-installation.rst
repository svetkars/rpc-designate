.. _prepare-installation:

Prepare for designate installation
==================================

Before deploying designate, you need to configure a few important components,
including a DNS server, ports, and an Remote Name Daemon Control (RNDC)
key. Then, create a DNS servers pool as described in
:ref:`configure-dns-server-pool` and then, run the designate
deployment script.

.. _setup-dns-backend:

Set up a DNS backend
~~~~~~~~~~~~~~~~~~~~

Although designate provides drivers to support different DNS
backends, RPC supports BIND 9 only. You can either use an existing DNS
deployment or set up new DNS nodes to work with designate.

To set up a DNS backend, follow these steps:

#. Enable the creation of new availability zone by configuring the
   following BIND 9 option:

   .. code-block:: yaml

      allow-new-zones yes;

#. Enable designate to communicate with BIND 9 by creating
   and configuring an ``rndc.key``:

   .. code-block:: bash

      include "/etc/bind/rndc.key";

      controls {
        inet <listen address> port 953
          allow { <ip addresses of infra nodes> ; } keys {"rndc-key"; };
        inet 127.0.0.1 port 953
          allow { 127.0.0.1; } keys {"rndc-key"; };
      };

   Fore more information, see :ref:`designate-rndc`.

.. _designate-ports:

Configure network ports
~~~~~~~~~~~~~~~~~~~~~~~

Designate must communicate bi-directionally with the
infrastructure nodes that run the designate containers and
the DNS servers.

.. list-table:: **Port configuration**
   :widths: 20 10 20
   :header-rows: 1

   * - Server
     - Port
     - Description
   * - Infrastructure nodes
     - 5354/UDP
     - The 5354/UDP must be open on all infrastructure nodes to allow
       ingress traffic. This port is used for the answers zone transfer
       (AXDR) requests from the DNS servers to the designate mini DNS
       (``designate-mdns``) service.

       DNS -> OpenStack infrastructure nodes.

   * - DNS servers
     - * 53/UDP
       * 53/TCP
       * 953/TCP
     -  DNS servers need the following ports to be open:

        * 53/UDP -> Open for all traffic for DNS resolution
        * 53/TCP -> Open for all traffic for DNS resolution
        * 953/TCP -> Used for RNDC commands, this only needs
          to be open to allow communication from the OpenStack
          infrastructure nodes.

        OpenStack Infra nodes -> DNS

.. _designate-rndc:

RNDC key
~~~~~~~~

RNDC enables configuration for DNS servers with the BIND 9 backend.
In different operating system the RNDC key file is either

.. list-table:: **RNDC key file**
   :widths: 20 20
   :header-rows: 1

   * - Operating system
     - Description
   * - Ubuntu
     - The BIND 9 package automatically generates an ``rndc.key``
       file in the /etc/bind directory.
   * - CentOS/RHEL
     - You need to generate the key file by using the ``rndc-confgen``
       command. This command creates the key file and places it in
       the ``/etc`` directory

       .. code-block:: bash

          rndc-confgen -a

       **System response:**

       .. code-block:: bash

          wrote key file "/etc/rndc.key"

       Copy the key file to the following location on
       the deployment host:

       .. code-block:: bash

          /etc/openstack_deploy/rndc.key
