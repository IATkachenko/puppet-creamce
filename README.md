# puppet-creamce

puppet module to install and configure a cream CE


## YAML configuration Parameters

The complete documentation for puppet is available [here](http://cream-guide.readthedocs.io/en/latest/index.html#) 

## Example of stand-alone installation and configuration for CentOS 7

### Puppet setup

Install EPEL extension: `yum -y install epel-release`

Install puppet: `yum -y install puppet`

Check if the hostname and FQDN is correctly detected by puppet:
```
facter | grep hostname
facter | grep fqdn
```
In the following examples the FQHN will be myhost.mydomain

Install the CREAM CE module for puppet: `puppet module install infnpd-creamce`

Apply the patch described in the tips&tricks section

Create the required directories: `mkdir -p /etc/puppet/manifests /var/lib/hiera/node`

Edit the file `/etc/puppet/manifests/site.pp` as:
```
node 'myhost.mydomain' {
  require creamce
}
```

Edit the file `/etc/hiera.yaml` as:
```
---
:backends:
  - yaml
:hierarchy:
  - "node/%{fqdn}"
:yaml:
  :datadir: /var/lib/hiera
```

Link the hiera configuration to puppet: `ln -s /etc/hiera.yaml /etc/puppet/hiera.yaml`

Edit the CREAM CE description file, an example of minimal configuration is:
```
---
creamce::mysql::root_password :      mysqlp@$$w0rd
creamce::creamdb::password :         creamp@$$w0rd
creamce::creamdb::minpriv_password : minp@$$w0rd
apel::db::pass :                     apelp@$$w0rd
creamce::batch_system :              pbs
creamce::use_argus :                 false
creamce::default_pool_size :         10
creamce::info::capability :          [ "CloudSupport=false", "Multinode=true" ]

creamce::repo_urls :                 [ 
                                       "http://repository.example.org/dist/CREAM/repos/centos7/cream.repo",
                                       "http://repository.example.org/dist/CREAM/repos/centos7/security_extras.repo"
                                     ]
creamce::rpm_key_urls :              [ "http://repository.example.org/dist/RPM-GPG-KEY-cream-dist" ]

gridftp::params::certificate :       "/etc/grid-security/hostcert.pem"
gridftp::params::key :               "/etc/grid-security/hostkey.pem"
gridftp::params::port :              2811

creamce::queues :
    long :  { groups : [ dteam, dteamprod ] }
    short : { groups : [ dteamsgm ] }

creamce::vo_table :
    dteam : { 
        vo_app_dir : /afs/dteam, 
        vo_default_se : storage.pd.infn.it,
        servers : [
                      {
                          server : voms.hellasgrid.gr,
                          port : 15004,
                          dn : /C=GR/O=HellasGrid/OU=hellasgrid.gr/CN=voms.hellasgrid.gr,
                          ca_dn : "/C=GR/O=HellasGrid/OU=Certification Authorities/CN=HellasGrid CA 2016"
                      },
                      {
                          server : voms2.hellasgrid.gr,
                          port : 15004,
                          dn : /C=GR/O=HellasGrid/OU=hellasgrid.gr/CN=voms2.hellasgrid.gr,
                          ca_dn : "/C=GR/O=HellasGrid/OU=Certification Authorities/CN=HellasGrid CA 2016"
                      }
        ],
        groups : {
            dteam : { fqan : [ "/dteam" ], gid : 9000 },
            
            dteamsgm : { fqan : [ "/dteam/sgm/ROLE=developer" ], gid : 9001, pub_admin : true },
            
            dteamprod : { fqan : [ "/dteam/prod/ROLE=developer" ], gid : 9002 }
        },
        users : {
            dteamusr : { first_uid : 6000, groups : [ dteam ], name_pattern : "%<prefix>s%03<index>d" },
            
            dteamsgmusr : { first_uid : 6100, groups : [ dteamsgm, dteam ], pool_size : 5, name_pattern : "%<prefix>s%02<index>d" },
            
            dteamprodusr : { first_uid : 6200, groups : [ dteamprod, dteam ], pool_size : 5, name_pattern : "%<prefix>s%02<index>d" }
        }
    }

creamce::hardware_table :
    subcluster001 : {
        ce_cpu_model : XEON,
        ce_cpu_speed : 2500,
        ce_cpu_vendor : Intel,
        ce_cpu_version : 5.1,
        ce_physcpu : 2,
        ce_logcpu : 2,
        ce_minphysmem : 2048,
        ce_minvirtmem : 4096,
        ce_os_family : "linux",
        ce_os_name : "CentOS",
        ce_os_arch : "x86_64",
        ce_os_release : "7.0.1406",
        ce_outboundip : true,
        ce_inboundip : false,
        ce_runtimeenv : [ "tomcat_6_0", "mysql_5_1" ],
        subcluster_tmpdir : /var/tmp/subcluster001,
        subcluster_wntmdir : /var/glite/subcluster001,
        ce_benchmarks : { specfp2000 : 420, specint2000 : 380, hep-spec06 : 780 },
        nodes : [ "node-01.mydomain", "node-02.mydomain", "node-03.mydomain" ]
        # Experimental support to GPUs
        accelerators : {
            acc_device_001 : {
                type : GPU,
                log_acc : 4,
                phys_acc : 2,
                vendor : NVidia,
                model : "Tesla k80",
                version : 4.0,
                clock_speed : 3000,
                memory : 4000 
            }
        }
    }

creamce::software_table :
    tomcat_6_0 : {
        name : "tomcat",
        version : "6.0.24",
        license : "ASL 2.0",
        description : "Tomcat is the servlet container" 
    }
    mysql_5_1 : {
        name : "mysql",
        version : "5.1.73",
        license : "GPLv2 with exceptions",
        description : "MySQL is a multi-user, multi-threaded SQL database server" 
    }

creamce::vo_software_dir : /afs

creamce::se_table :
    storage.pd.infn.it : { mount_dir : "/data/mount", export_dir : "/storage/export", type : Storm, default : true }
    cloud.pd.infn.it : { mount_dir : "/data/mount", export_dir : "/storage/export",  type : Dcache }
```

Create the directory for credential: `mkdir -p /etc/grid-security`

Deploy the host key in `/etc/grid-security/hostkey.pem`

Deploy the host certificate in `/etc/grid-security/hostcert.pem`

Run puppet: `puppet apply --verbose /etc/puppet/manifests/site.pp`

## Managing the CREAM services

The CREAM services, Tomcat, BLAH notifier and locallogger (if required), can be managed via systemd with the target **glite-services.target**:
```
systemctl stop glite-services.target
systemctl start glite-services.target
```


