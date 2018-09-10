class creamce::config inherits creamce::params {
  
  require creamce::certificate
  
  require creamce::poolaccount
  
  # ##################################################################################################
  # Packages and installation
  # ##################################################################################################

  package { "$tomcat":
    ensure  => present,
    tag     => [ "creamcepackages" ],
  }
  
  package { ["glite-ce-cream", "canl-java-tomcat" ]: 
    ensure   => present,
    require  => Package["${tomcat}"],
    tag      => [ "creamcepackages", "umdpackages" ],
  }
  
  package { "mysql-connector-java":
    ensure   => present,
    require  => Package["${tomcat}"],
    tag      => [ "creamcepackages" ],
  }
  
  file { "${tomcat_server_lib}/commons-logging.jar":
    ensure    => link,
    target    => "/usr/share/java/commons-logging.jar",
    subscribe => Package["${tomcat}"],
  }

  # ##################################################################################################
  # Environment setup
  # ##################################################################################################

  file { "/etc/profile.d/grid-env.sh":
    ensure  => present,
    content => template("creamce/gridenvsh.erb"),
    owner   => "root",
    group   => "root",
    mode    => '0755',
    tag     => [ "gridenvfiles" ],
  }  

  file { "/etc/profile.d/grid-env.csh":
    ensure  => present,
    content => template("creamce/gridenvcsh.erb"),
    owner   => "root",
    group   => "root",
    mode    => '0644',
    tag     => [ "gridenvfiles" ],
  }

  # ##################################################################################################
  # Sudo setup
  # ##################################################################################################

  $sudo_table = build_sudo_table($voenv, $default_pool_size, $username_offset)

  package { "sudo":
    ensure => present
  }

  file { "/etc/sudoers.d/50_cream_users":
    ensure  => file,
    owner   => "root",
    group   => "root",
    mode    => '0440',
    content => template("creamce/sudoers_forcream.erb"),
    require => Package["sudo"],
    tag     => [ "tomcatcefiles" ],
  }

  unless $sudo_logfile == "" {

    file { "${sudo_logfile}":
      ensure  => file,
      owner   => "root",
      group   => "root",
      mode    => '0640',      
      tag     => [ "tomcatcefiles" ],
    }

  }
  
  #Creamce::Pooluser <| |> -> File["/etc/sudoers.d/50_cream_users"]

  # ##################################################################################################
  # Glexec setup
  # ##################################################################################################

  unless $use_argus {

    require creamce::lcmaps
  
    package { "glexec":
      ensure  => present,
    }

    file { "/usr/sbin/glexec":
      ensure  => file,
      owner   => "root",
      group   => "glexec",
      mode    => '6555',
      require => Package["glexec"]
    }

    file { "/var/log/glexec":
      ensure  => directory,
      owner   => "root",
      group   => "root",
      mode    => '0755',
      require => Package["glexec"]
    }

    file {"/etc/glexec.conf":
      ensure  => present,
      content => template("creamce/glexec.conf.erb"),
      owner   => "root",
      group   => "glexec",
      mode    => '0640',
      require => Package["glexec"]
    }

    unless $glexec_log_file == "" {

      file {"/etc/logrotate.d/glexec":
        ensure  => present,
        content => template("creamce/glexec-logrotate.erb"),
        owner   => "root",
        group   => "root",
        mode    => '0644',
        require => Package["glexec"]
      }

    }

  }

  # ##################################################################################################
  # VOMS setup
  # ##################################################################################################

  file { "/etc/vomses":
    ensure  => directory,
    owner   => "root",
    group   => "root",
    mode    => '0755',
  }
  
  file { "${voms_dir}":
    ensure  => directory,
    owner   => "root",
    group   => "root",
    mode    => '0755',
  }
  
  $vopaths = prefix(keys($voenv), "${voms_dir}/")
  file { $vopaths:
    ensure  => directory,
    owner   => "root",
    group   => "root",
    mode    => '0755',
    require => File["${voms_dir}"],
  }
  
  $vo_table = build_vo_definitions($voenv, "${voms_dir}")
  create_resources(creamce::vofiles, $vo_table)

  # ##################################################################################################
  # Database setup
  # See https://forge.puppetlabs.com/puppetlabs/mysql
  # ##################################################################################################

  if $access_by_domain {
    $access_pattern = "%.${cream_db_domain}"
  } else {
    $access_pattern = "${cream_db_host}"
  }
  
  class { 'mysql::server':
    root_password      => $mysql_password,
    override_options   => $mysql_override_options
  }
  
  # --------------------------------------------------------------------------------------------------
  # configuration files
  # --------------------------------------------------------------------------------------------------
  
  #
  # TODO verify privileges and move into gip.pp in case
  #
  file { "/etc/glite-ce-dbtool/creamdb_min_access.conf":
    ensure   => present,
    content  => template("creamce/creamdb_min_access.conf.erb"),
    owner    => "root",
    group    => "root",
    mode     => '0644',
    tag      => [ "dbconffiles" ],
  }

  #
  # TODO use scripts from package
  #
  file { "/etc/glite-ce-cream/populate_creamdb_mysql.puppet.sql":
    ensure   => present,
    content  => template("creamce/populate_creamdb_mysql.sql.erb"),
    owner    => "root",
    group    => "root",
    mode     => '0600',
    require  => Class['mysql::server'],
    tag      => [ "dbconffiles" ],
  }
  
  file { "/etc/glite-ce-cream/populate_delegationcreamdb.puppet.sql":
    ensure   => present,
    content  => template("creamce/populate_delegationcreamdb.sql.erb"),
    owner    => "root",
    group    => "root",
    mode     => '0600',
    require  => Class['mysql::server'],
    tag      => [ "dbconffiles" ],
  }

  Package <| tag == 'creamcepackages' |> -> File <| tag == 'dbconffiles' |>

  # --------------------------------------------------------------------------------------------------
  # create database
  # --------------------------------------------------------------------------------------------------
  
  mysql_database { "${cream_db_name}":
    ensure   => 'present',
    charset  => 'latin1',
    collate  => 'latin1_general_ci',
    require  => Class['mysql::server'],
  }
  
  mysql_database { "${delegation_db_name}":
    ensure   => 'present',
    charset  => 'latin1',
    collate  => 'latin1_general_ci',
    require  => Class['mysql::server'],
  }
  
  # --------------------------------------------------------------------------------------------------
  # tables
  # --------------------------------------------------------------------------------------------------
  
  exec { "populate-creamdb":
    command     => "mysql -h localhost -u root --password=\"${mysql_password}\" ${cream_db_name} < /etc/glite-ce-cream/populate_creamdb_mysql.puppet.sql",
    refreshonly => true,
    logoutput   => true,
    path        => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin',
    timeout     => 300,
    require     => File["/etc/glite-ce-cream/populate_creamdb_mysql.puppet.sql"],
    subscribe   => Mysql_database["${cream_db_name}"],
  }

  exec { "populate-delegationdb":
    command     => "mysql -h localhost -u root --password=\"${mysql_password}\" ${delegation_db_name} < /etc/glite-ce-cream/populate_delegationcreamdb.puppet.sql",
    refreshonly => true,
    logoutput   => true,
    path        => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin',
    timeout     => 300,
    require     => File["/etc/glite-ce-cream/populate_delegationcreamdb.puppet.sql"],
    subscribe   => Mysql_database["${delegation_db_name}"],
  }
  
  # --------------------------------------------------------------------------------------------------
  # users
  # --------------------------------------------------------------------------------------------------

  $enc_std_password = mysql_password("${cream_db_password}")
  $enc_min_password = mysql_password("${cream_db_minpriv_password}")
  
  mysql_user { [ "${cream_db_user}@${access_pattern}", "${cream_db_user}@localhost" ]:
    ensure        => $ensure,
    password_hash => $enc_std_password,
    require       => Class['mysql::server'],
  }
  
  mysql_user { [ "${cream_db_minpriv_user}@${access_pattern}", "${cream_db_minpriv_user}@localhost" ]:
    ensure        => $ensure,
    password_hash => $enc_min_password,
    require       => Class['mysql::server'],
  }

  # --------------------------------------------------------------------------------------------------
  # grants
  # --------------------------------------------------------------------------------------------------
  
  mysql_grant { "${cream_db_user}@${access_pattern}/${cream_db_name}.*":
    privileges => 'ALL',
    user       => "${cream_db_user}@${access_pattern}",
    table      => "${cream_db_name}.*",
    require    => [ Mysql_database["${cream_db_name}"], Mysql_user["${cream_db_user}@${access_pattern}"] ],
  }

  mysql_grant { "${cream_db_user}@localhost/${cream_db_name}.*":
    privileges => 'ALL',
    user       => "${cream_db_user}@localhost",
    table      => "${cream_db_name}.*",
    require    => [ Mysql_database["${cream_db_name}"], Mysql_user["${cream_db_user}@localhost"] ],
  }

  mysql_grant { "${cream_db_user}@${access_pattern}/${delegation_db_name}.*":
    privileges => 'ALL',
    user       => "${cream_db_user}@${access_pattern}",
    table      => "${delegation_db_name}.*",
    require    => [ Mysql_database["${delegation_db_name}"], Mysql_user["${cream_db_user}@${access_pattern}"] ],
  }

  mysql_grant { "${cream_db_user}@localhost/${delegation_db_name}.*":
    privileges => 'ALL',
    user       => "${cream_db_user}@localhost",
    table      => "${delegation_db_name}.*",
    require    => [ Mysql_database["${delegation_db_name}"], Mysql_user["${cream_db_user}@localhost"] ],
  }
  
  mysql_grant { "${cream_db_minpriv_user}@${access_pattern}/${cream_db_name}.db_info":
    privileges => ['SELECT (submissionEnabled,startUpTime)'],
    options    => ['GRANT'],
    user       => "${cream_db_minpriv_user}@${access_pattern}",
    table      => "${cream_db_name}.db_info",
    require    => [ Exec["populate-creamdb"], Mysql_user["${cream_db_minpriv_user}@${access_pattern}"] ],
  }
    
  mysql_grant { "${cream_db_minpriv_user}@localhost/${cream_db_name}.db_info":
    privileges => ['SELECT (submissionEnabled,startUpTime)'],
    options    => ['GRANT'],
    user       => "${cream_db_minpriv_user}@localhost",
    table      => "${cream_db_name}.db_info",
    require    => [ Exec["populate-creamdb"], Mysql_user["${cream_db_minpriv_user}@localhost"] ],
  }

  # ##################################################################################################
  # Tomcat setup
  # ##################################################################################################

  file { "${tomcat_cert}":
    ensure   => file,
    owner    => "tomcat",
    group    => "root",
    mode     => '0644',
    source   => [$host_certificate],
    tag     => [ "tomcatcefiles" ],
  }
  
  file { "${tomcat_key}":
    ensure   => file,
    owner    => "tomcat",
    group    => "root",
    mode     => '0400',
    source   => [$host_private_key],
    tag     => [ "tomcatcefiles" ],
  }

  file {"/etc/${tomcat}/server.xml":
    ensure  => present,
    content => template("creamce/server.xml.erb"),
    owner   => "tomcat",
    group   => "tomcat",
    mode    => '0660',
    tag     => [ "tomcatcefiles" ],
  }
  
  file {"/etc/${tomcat}/${tomcat}.conf":
    ensure  => present,
    content => template("creamce/tomcat.conf.erb"),
    owner   => "root",
    group   => "root",
    mode    => '0660',
    tag     => [ "tomcatcefiles" ],
  }

  # ##################################################################################################
  # CREAM setup
  # ##################################################################################################
  
  $cluster_list = get_clusters_list($subclusters, $glue_2_1)

  file { "${cream_db_sandbox_path}":
    ensure => directory,
    owner  => "tomcat",
    group  => "tomcat",
    mode   => '0775',
  }
  
  $sb_definitions = build_sb_definitions($voenv, $cream_db_sandbox_path)
  create_resources(file, $sb_definitions)
  Package <| tag == 'creamcepackages' |> -> File["$cream_db_sandbox_path"]
  File["$cream_db_sandbox_path"] -> File <| tag == 'creamce::sandboxdirs' |>

  file { "/var/log/cream":
    ensure => directory,
    owner  => "tomcat",
    group  => "tomcat",
    mode   => '0775',
    tag    => [ "tomcatcefiles" ],
  }

  file{"/etc/sysconfig/edg":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => '0644',
    content => template("creamce/edg.erb"),
  }
 
  file{"/etc/sysconfig/cream":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => '0400',
    content => template("creamce/cream.erb"),
    tag     => [ "tomcatcefiles" ],
  }
 
  file {"/etc/glite-ce-cream/cream-config.xml":
    ensure  => present,
    content => template("creamce/cream-config.xml.erb"),
    owner   => "tomcat",
    group   => "tomcat",
    mode    => '0640',
    tag     => [ "tomcatcefiles" ],
  }

  file {"/etc/glite-ce-cream-utils/glite_cream_load_monitor.conf":
    ensure  => present,
    content => template("creamce/glite_cream_load_monitor.conf.erb"),
    owner   => "tomcat",
    group   => "root",
    mode    => '0640',
    tag     => [ "tomcatcefiles" ],
  }

  file { "${cream_admin_list_file}":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => '0644',
    content => template("creamce/adminlist.erb"),
    tag     => [ "tomcatcefiles" ],
  }  

  Package <| tag == 'creamcepackages' |> -> File <| tag == 'tomcatcefiles' |>

  # ##################################################################################################
  # Tomcat service
  # ##################################################################################################

  service { "$tomcat":
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    alias      => "tomcat",
  }
  
  File <| tag == 'gridenvfiles' |> ~> Service["$tomcat"]
  File <| tag == 'tomcatcefiles' |> ~> Service["$tomcat"]
  File <| tag == 'vomscefiles' |> ~> Service["$tomcat"]
  Mysql_grant <| |> ~> Service["$tomcat"]

  if $::operatingsystem == "CentOS" and $::operatingsystemmajrelease in [ "7" ] {

    file { "/etc/systemd/system/tomcat.service.d":
      ensure => directory,
      owner  => "root",
      group  => "root",
      mode   => '0644',
    }
    
    file { "/etc/systemd/system/tomcat.service.d/10-glite-services.conf":
      ensure  => present,
      owner   => "root",
      group   => "root",
      mode    => '0644',
      content => "[Unit]
PartOf=glite-services.target
",
      require => File["/etc/systemd/system/tomcat.service.d"],
      tag     => [ "glitesystemdfiles" ],
    }

    if $use_loclog {
      $glite_service_defs = "[Unit]
Description=Master service for CREAM CE
Requires=tomcat.service glite-ce-blah-parser.service glite-lb-logd.service glite-lb-interlogd.service
"
    } else {
      $glite_service_defs = "[Unit]
Description=Master service for CREAM CE
Requires=tomcat.service glite-ce-blah-parser.service
"
    }

    file { "/lib/systemd/system/glite-services.target":
      ensure  => present,
      owner   => "root",
      group   => "root",
      mode    => '0644',
      content => "${glite_service_defs}",
    }
    
    File <| tag == 'glitesystemdfiles' |> -> File["/lib/systemd/system/glite-services.target"]
  }

}

