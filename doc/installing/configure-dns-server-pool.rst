.. _configure-dns-server-pool:

Configure a DNS server pool
===========================

Designate supports multiple pools of DNS servers which enable network
operators to scale networks as needed, as well as separate internal
and external availability zones. Place the DNS server pool file
``designate_pool.yml``) in the OpenStack deploy directory.
You can use the [sample](doc/sample_designate_pool.yml) DNS pool
file that is stored in this repository and add changes as needed.

The following table provides descritpions of important sections in
the configuration file:

.. list-table::
   :widths: 20 20 20
   :header-rows: 1

   * - Paramater
     - Example value
     - Description
   * - ``name: default``
     - ``description: Default Pool``
     - Name of the DNS servers pool
   * - ``ns_records``
     - .. code-block:: bash

          ns_records:
           - hostname: ns1-1.example.org.
             priority: 1
     - A list of the name server (NS) records for the
       zones that are hosted within this pool.
   * - ``nameservers``
     - .. code-block:: bash

          nameservers:
          - host: 127.0.0.1
            port: 53

     - A list out all name servers to test against. The servers
       are used to confirm that the zone changes have been successfully
       applied.
   * - ``targets``
     - .. code-block:: bash

          targets:
            - type: bind9
              description: BIND 9 Server 1

       .. code-block:: bash

          masters:
            - host: 127.0.0.1
              port: 5354

       .. code-block:: bash

          options:
            host: 127.0.0.1
            port: 53
            rndc_host: 127.0.0.1
            rndc_port: 953
            rndc_key_file: /etc/designate/rndc.key

     - The ``targets`` section is where you define the target name server on
       which you perform actions. For each external DNS server, you need add
       one of the following sections.

       Use type ``bind9`` in all configurations because that is the only
       currently supported option for RPC.

       The ``masters`` section defines the DNS servers that have
       primary zones. Typically, this is where you put the IP addresses of
       the infrastructure nodes.

       Under the ``options`` you define IP addresses, ports, and the RNDC
       information for the external DNS servers.
