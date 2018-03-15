Installation of RPC-Designate
==============================
Table of Contents
=================
<!--ts-->
- [Installation of RPC-Designate](#installation-of-rpc-designate)
- [Table of Contents](#table-of-contents)
- [<!--te-->](#te)
- [Prerequisites](#prerequisites)
  - [Setup DNS Server](#setup-dns-server)
  - [Ports](#ports)
  - [RNDC Key File](#rndc-key-file)
    - [Ubuntu](#ubuntu)
    - [CentOS/RHEL](#centosrhel)
- [Configuration](#configuration)
    - [Name](#name)
    - [ns_records](#nsrecords)
    - [nameservers](#nameservers)
    - [targets](#targets)
<!--te-->
Installation
=============

The basic installation of Designate can be performed by running the scripts/deploy.sh script. The rest of the documentation remains for details on how to manually configure service. The deploy script will do the following:
- Detect what version of OpenStack you are running against
- Create containers for bind and for Designate on all infra hosts
- Deploy bind and configure for use with Designate
- Create a pool configuration "/etc/openstack_deploy/designate_pools.yml" to setup Designate to work with installed bind
- Deploy Designate using default configuration
- Configure firewall on infra hosts to allow communication to bind from infra IP address

Prerequisites
=============

Setup DNS Server
----------------
Designate has drivers to work with a number of different DNS back ends, the only that is supported by RPC currently is BIND9. You can either use a existing dns deployment or you can setup new DNS nodes to work with Designate.

The BIND9 configuration must have to following option defined to allow new zones to be created.

```
allow-new-zones yes;
```

To allow Designate to communicate with BIND, a rndc.key need to be created and configured for use.

```
include "/etc/bind/rndc.key";

controls {
  inet <listen address> port 953
    allow { <ip addresses of infra nodes> ; } keys {"rndc-key"; };
  inet 127.0.0.1 port 953
    allow { 127.0.0.1; } keys {"rndc-key"; };
};
```


Ports
------
Designate need to have bi-directional communication between the infra nodes that are running the designate containers and the DNS servers. 
1. Port 5354/udp needs to be open on the infra nodes to allow ingres traffic
   1. This port is used for the AXDRs from the DNS servers to the designate-mdns service 
   1. DNS -> OpenStack Infra Nodes

1. The DNS servers need the following ports open
   1. 53/udp -> Open for all traffic for DNS resolution
   2. 53/tcp -> Open for all traffic for DNS resolution
   3. 953/tcp -> Used for rndc commands, this only needs to be open to allow communications from the OpenStack Infra nodes
      1. OpenStack Infra nodes -> DNS 

RNDC Key File
--------------
### Ubuntu
The bind9 package will generate a rndc.key file in the /etc/bind directory. 
### CentOS/RHEL
The key file will need to be generated using rndc-confgen. This will create the key file and place it in the /etc directory.
```
# rndc-confgen -a
wrote key file "/etc/rndc.key"
```

They key file needs ot be copied to this location on the deployment host
```
/etc/openstack_deploy/rndc.key
```

Configuration
=============
Designate Pool

The deploy script assumes that the designate_pool.yml file is in the OpenStack deploy directory.
A [sample](doc/sample_designate_pool.yml) file has been included in the doc directory of this repository. 

There are several section to this map:

### Name
```
    - name: default
    description: Default Pool
```

### ns_records
We need to list out the NS records for the zones we are hosting within this pool
```  
   ns_records:
    - hostname: ns1-1.example.org.
      priority: 1
```
### nameservers
This section is where we list out all of the name server that we are testing against.
They are used to confirm that the zone changes have been made.
```
    nameservers:
    - host: 127.0.0.1
      port: 53
```
### targets
The targets section is where you define the target name server that you will be performing actions against. There are several sections that we need to pay attention to. There will be one of these sections for each external DNS server that are being used.
The type will be bind9 as that is the only currently supported option for RPC
```
  targets:
    - type: bind9
      description: BIND9 Server 1
```
The masters section is where the DNS servers that have the primary zones are defined. Normally this would be the addresses of the infra nodes. 
```
      masters:
        - host: 127.0.0.1
          port: 5354
```
Under the options you define the IP address, port and rndc information for the external DNS servers.

```   options:
        host: 127.0.0.1
        port: 53
        rndc_host: 127.0.0.1
        rndc_port: 953
        rndc_key_file: /etc/designate/rndc.key
```