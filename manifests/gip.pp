class creamce::gip inherits creamce::params {

  require creamce::poolaccount

  $queue_vo_map = build_queue_vo_map($grid_queues, $voenv)
  
  $cluster_list = get_clusters_list($subclusters, $glue_2_1)

  package { [
              "bdii",
              "glite-info-provider-service",
              "glite-ce-cream-utils",
              "dynsched-generic",
              "glue-schema"
            ]:
    ensure   => present,
    tag      => [ "umdpackages" ],
  }
  
  # ##################################################################################################
  # BDII setup
  # ##################################################################################################

  file {"/etc/bdii/bdii.conf":
    content => template('creamce/bdiiconf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    tag     => ['bdiisetup'],
  }

  file { "/etc/bdii/gip":
    ensure  => "directory",
    owner   => "root",
    group   => "root",
    mode    => '0755',
    tag     => ['bdiisetup'],
  }

  file {"/etc/sysconfig/bdii":
    content => template('creamce/bdiisysconf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    tag     => ['bdiisetup'],
  }

  file_line { 'slapd_threads':
    path    => "${slapdconf}",
    match   => "^\s*threads",
    line    => "threads          ${slapdthreads}",
    tag     => ['bdiisetup'],
  }

  file_line { 'slapd_loglevel':
    path    => "${slapdconf}",
    match   => "^\s*loglevel",
    line    => "loglevel       ${slapdloglevel}",
    tag     => ['bdiisetup'],
  }

  Package["bdii"] -> File <| tag == 'bdiisetup' |> ~> Service["bdii"]
  Package["bdii"] -> File_line <| tag == 'bdiisetup' |> ~> Service["bdii"]

  # ##################################################################################################
  # Experimental features and misc.
  # ##################################################################################################

  if $glue_2_1 {
    file { "/etc/ldap/schema/GLUE2.1-draft.schema":
      ensure  => file,
      owner   => "root",
      group   => "root",
      mode    => '0744',
      content => template("creamce/GLUE2.1-draft.schema.erb"),
      require => Package["glue-schema"],
    }

    exec { "replace_glue_schema_top":
      command => "/usr/bin/sed -i 's/GLUE20.schema/GLUE2.1-draft.schema/g' /etc/bdii/bdii-top-slapd.conf",
      require => File["/etc/ldap/schema/GLUE2.1-draft.schema"],
      notify  => Service["bdii"],
    }

    exec { "replace_glue_schema_resource":
      command => "/usr/bin/sed -i 's/GLUE20.schema/GLUE2.1-draft.schema/g' /etc/bdii/bdii-slapd.conf",
      require => File["/etc/ldap/schema/GLUE2.1-draft.schema"],
      notify  => Service["bdii"],
    }
  }
  
  # ##################################################################################################
  # vo tag dir setup
  # ##################################################################################################

  file { "${gridft_pub_dir}":
    ensure => directory,
    owner  => "root",
    group  => "root",
    mode   => '0755',
  }
  
  $tagdir_defs = build_tagdir_definitions($voenv, $gridft_pub_dir, $username_offset)
  create_resources(creamce::tagspace, $tagdir_defs)
  
  File["${gridft_pub_dir}"] -> Creamce::Tagspace <| |>
  
  # ##################################################################################################
  # common plugin 
  # ##################################################################################################

  file { "/etc/glite-ce-glue2/glite-ce-glue2.conf":
    ensure  => file,
    owner   => "root",
    group   => "root",
    mode    => '0755',
    content => template("creamce/gip/glite-ce-glue2.conf.erb"),
    require => Package["glite-ce-cream-utils"],
  }

  file { "$gippath/plugin/glite-info-cream-glue2":
    ensure  => file,
    owner   => "${info_user}",
    group   => "${info_group}",
    mode    => '0755',
    content => template("creamce/gip/glite-info-cream-glue2.erb"),
    require => File["/etc/glite-ce-glue2/glite-ce-glue2.conf"],
    notify  => Service["bdii"],
  }
  
  file { "$gippath/plugin/glite-info-service-data":
    ensure  => file,
    owner   => "${info_user}",
    group   => "${info_group}",
    mode    => '0755',
    content => template("creamce/gip/glite-info-service-data.erb"),
    require => Package["bdii"],
    notify  => Service["bdii"],
  }

  # ##################################################################################################
  # common provider
  # ##################################################################################################

  file{ "/etc/glite/info/service/glite-info-service-cream.conf":
    ensure  => file,
    owner   => "root",
    group   => "root",
    mode    => '0644',
    content => template("creamce/glite-info-service-cream.conf.erb"),
    require => Package["glite-info-provider-service"],
  }
  
  file { "$gippath/provider/glite-info-provider-service-cream-wrapper":
    ensure  => file,
    owner   => "${info_user}",
    group   => "${info_group}",
    mode    => '0755',
    content => template("creamce/gip/glite-info-provider-service-cream-wrapper.erb"),
    require => File["/etc/glite/info/service/glite-info-service-cream.conf"],
    notify  => Service["bdii"],
  }
  
  # ##################################################################################################
  # common ldif
  # ##################################################################################################

  file {"$gippath/ldif/static-file-CE.ldif":
    ensure  => file,
    owner   => "${info_user}",
    group   => "${info_group}",
    mode    => '0644',
    content => template("creamce/gip/static-file-CE.ldif.erb"),
    tag     => ['bdiildifdefs'],
  }
  
  file { "$gippath/ldif/ComputingEndpoint.ldif":
    ensure  => file,
    mode    => '0644',
    owner   => "${info_user}",
    group   => "${info_group}",
    content => template("creamce/gip/computingendpoint.ldif.erb"),
    tag     => ['bdiildifdefs'],
  }
  
  file { "$gippath/ldif/ComputingService.ldif":
    ensure  => file,
    mode    => '0644',
    owner   => "${info_user}",
    group   => "${info_group}",
    content => template("creamce/gip/computing_service.ldif.erb"),
    tag     => ['bdiildifdefs'],
  }

  file {'/var/tmp/info-dynamic-scheduler-generic':
    ensure  => directory,
    owner   => "${info_user}",
    group   => "${info_group}",
    mode    => '0755',
    require => Package["bdii", "dynsched-generic"],
  }
  
  if $clustermode {
  
    # ################################################################################################
    # ldif files
    # ################################################################################################
    file { "$gippath/ldif/ComputingShare.ldif":
      ensure  => file,
      mode    => '0644',
      owner   => "${info_user}",
      group   => "${info_group}",
      content => "\n",
      tag     => ['bdiildifdefs'],
    }  

    file { "$gippath/ldif/ComputingManager.ldif":
      ensure  => file,
      mode    => '0644',
      owner   => "${info_user}",
      group   => "${info_group}",
      content => "\n",
      tag     => ['bdiildifdefs'],
    }
    
  } else {
    
    # ################################################################################################
    # plugin
    # ################################################################################################

    file {"$gippath/plugin/glite-info-dynamic-software-wrapper":
      ensure  => file,
      owner   => "${info_user}",
      group   => "${info_group}",
      mode    => '0755',
      content => template("creamce/gip/glite-info-dynamic-software-wrapper.erb"),
      require => [ Package["glite-ce-cream-utils"], File["$gippath/ldif/static-file-Cluster.ldif"] ],
      notify  => Service["bdii"],
    }
  
    # ################################################################################################
    # providers
    # ################################################################################################

    file {"$gippath/provider/glite-info-glue2-applicationenvironment-wrapper":
      ensure  => file,
      owner   => "${info_user}",
      group   => "${info_group}",
      mode    => '0755',
      content => template("creamce/gip/glite-info-glue2-applicationenvironment-wrapper.erb"),
      require => [
        Package["glite-ce-cream-utils"],
        File["$gippath/ldif/static-file-Cluster.ldif", "/etc/glite-ce-glue2/glite-ce-glue2.conf"]
      ],
      notify  => Service["bdii"],
    }
   
    file{ "/etc/glite/info/service/glite-info-glue2-rtepublisher.conf":
      ensure  => file,
      owner   => "root",
      group   => "root",
      mode    => '0644',
      content => template("creamce/glite-info-glue2-rtepublisher.conf.erb"),
      require => Package["glite-info-provider-service"],
    }

    file{ "/etc/glite/info/service/glite-info-service-rtepublisher.conf":
      ensure  => file,
      owner   => "root",
      group   => "root",
      mode    => '0644',
      content => template("creamce/glite-info-service-rtepublisher.conf.erb"),
      require => Package["glite-info-provider-service"],
    }

    file { "$gippath/provider/glite-info-provider-service-rtepublisher-wrapper":
      ensure  => file,
      owner   => "${info_user}",
      group   => "${info_group}",
      mode    => '0755',
      content => template("creamce/gip/glite-info-provider-service-rtepublisher-wrapper.erb"),
      require => File[
        "/etc/glite/info/service/glite-info-glue2-rtepublisher.conf",
        "/etc/glite/info/service/glite-info-service-rtepublisher.conf"
      ],
      notify  => Service["bdii"],
    }

    # ################################################################################################
    # ldif files
    # ################################################################################################
    file { "$gippath/ldif/ComputingManager.ldif":
      ensure  => file,
      mode    => '0644',
      owner   => "${info_user}",
      group   => "${info_group}",
      content => template("creamce/gip/computing_manager.ldif.erb"),
      tag     => ['bdiildifdefs'],
    }

    file { "$gippath/ldif/ComputingShare.ldif":
      ensure  => file,
      mode    => '0644',
      owner   => "${info_user}",
      group   => "${info_group}",
      content => template("creamce/gip/computing_share.ldif.erb"),
      tag     => ['bdiildifdefs'],
    }

    file { "$gippath/ldif/ExecutionEnvironment.ldif":
      ensure  => file,
      mode    => '0644',
      owner   => "${info_user}",
      group   => "${info_group}",
      content => template("creamce/gip/executionenvironment.ldif.erb"),
      tag     => ['bdiildifdefs'],
    }

    file { "$gippath/ldif/Benchmark.ldif":
      ensure  => file,
      mode    => '0644',
      owner   => "${info_user}",
      group   => "${info_group}",
      content => template("creamce/gip/benchmark.ldif.erb"),
      tag     => ['bdiildifdefs'],
    }

    file { "$gippath/ldif/ToStorageService.ldif":
      ensure  => file,
      mode    => '0644',
      owner   => "${info_user}",
      group   => "${info_group}",
      content => template("creamce/gip/tostorageservice.ldif.erb"),
      tag     => ['bdiildifdefs'],
    }

    file {"$gippath/ldif/static-file-CESEBind.ldif":
      ensure  => file,
      owner   => "${info_user}",
      group   => "${info_group}",
      mode    => '0644',
      content => template("creamce/gip/static-file-CESEBind.ldif.erb"),
      tag     => ['bdiildifdefs'],
    }

    file {"$gippath/ldif/static-file-Cluster.ldif":
      ensure  => file,
      owner   => "${info_user}",
      group   => "${info_group}",
      mode    => '0644',
      content => template("creamce/gip/static-file-Cluster.ldif.erb"),
      tag     => ['bdiildifdefs'],
    }  
    
  }
  
  Package["bdii"] -> File <| tag == 'bdiildifdefs' |> ~> Service["bdii"]
  
  service { "bdii":
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }

}
