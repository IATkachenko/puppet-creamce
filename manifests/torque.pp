class creamce::torque inherits creamce::params {

  include creamce::blah
  include creamce::gip
  
  $vo_group_table = build_vo_group_table($voenv)
  
  # ##################################################################################################
  # BLAHP setup (TORQUE)
  # ##################################################################################################

  file { "${blah_config_file}":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => '0644',
    content => template("creamce/blah.config.torque.erb"),
    tag     => [ "blahconffiles" ],
  }
  
  if $use_blparser {

    file { "/etc/blparser.conf":
      ensure  => present,
      owner   => "root",
      group   => "root",
      mode    => '0644',
      content => template("creamce/blparser.conf.torque.erb"),
      tag     => [ "blahconffiles" ],
    }

    $file_to_rotate = "/var/log/cream/glite-pbsparser.log"
    
    file { "/etc/logrotate.d/glite-pbsparser":
      ensure  => present,
      owner   => "root",
      group   => "root",
      mode    => '0644',
      content => template("creamce/blahp-logrotate.erb"),
      tag     => [ "blahconffiles" ],
    }
    
  }
  
  if $use_blparser or $istorqueinstalled == "true" {

    # realization of virtual resource Service["glite-ce-blah-parser"]
    File <| tag == 'blahconffiles' |> ~> Service <| tag == 'blahparserservice' |>

  }
  
  #
  # TODO check https://wiki.italiangrid.it/twiki/bin/view/CREAM/SystemAdministratorGuideForEMI3#1_2_5_Choose_the_BLAH_BLparser_d
  #

  # ##################################################################################################
  # TORQUE infoproviders
  # ##################################################################################################

  package { "lcg-info-dynamic-scheduler-pbs":
    ensure  => present,
    tag     => [ "bdiipackages", "umdpackages" ],
  }
  
  file { "/etc/lrms/scheduler.conf":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => '0644',
    content => template("creamce/gip/torque-provider.conf.erb"),
    require => Package["lcg-info-dynamic-scheduler-pbs"],
    notify  => Service["bdii"],
  }
  
  if $usemaui == "true" {
  
    file { "/var/spool/maui/maui.cfg":
      ensure  => present,
      owner   => "root",
      group   => "root",
      mode    => '0644',
      content => template("creamce/maui.cfg.erb"),
    }
    
    info("Maui scheduler configured")
    
  } else {
  
    warning("Cannot detect Maui scheduler installation, please configure it manually")
    
  }
  
  # ##################################################################################################
  # TORQUE client
  # ##################################################################################################
  
  if $torque_config_client and $istorqueinstalled == "false" {
  
    package { "munge":
      ensure  => present,
    }

    file { "/etc/torque/server_name":
      ensure  => present,
      owner   => "root",
      group   => "root",
      mode    => '0644',
      content => "${torque_server}",
      require => Package["torque-client"],
    }
  
    if $munge_key_path == "" {

      fail("Munge key not defined")

    } else {

      service { [ "munge", "trqauthd" ]:
        ensure   => running,
        require  => [ File["/etc/torque/server_name"], Package["munge"] ],
      }
  
      file { "/etc/munge/munge.key":
        ensure  => present,
        owner   => "munge",
        group   => "munge",
        mode    => '0400',
        source  => "${munge_key_path}",
        require => Package["munge"],
        notify  => Service["munge"],
      }

    }
    
  }

  if $cream_config_ssh {

    class { 'creamce::sshconfig':
      lrms_host_script => "/usr/bin/pbsnodes -a -s ${torque_server}",
      lrms_master_node => $torque_server
    }

  }

  if $torque_config_pool {    

    $queue_group_table = build_queue_group_tuples($grid_queues)
    
    create_resources(creamce::torquemember, $queue_group_table)
    
    if $torque_config_client and $istorqueinstalled == "false" {

      Service["munge", "trqauthd"] -> Creamce::Torquemember <| |>

    }
    
  }

}
