class creamce::blah inherits creamce::params {

  # ##################################################################################################
  # BLAHP Package
  # ##################################################################################################

  package { "${blah_package}":
    ensure  => present,
    tag     => [ "creamcepackages", "umdpackages" ],
  }

  # ##################################################################################################
  # BLAHP setup (common actions)
  # ##################################################################################################

  file { "/var/log/cream/accounting":
    ensure => directory,
    owner  => "root",
    group  => "tomcat",
    mode   => '0730',
    tag    => [ "blahconffiles" ],
  }

  file { "/var/blah":
    ensure => directory,
    owner  => "tomcat",
    group  => "tomcat",
    mode   => '0771',
    tag    => [ "blahconffiles" ],
  }

  $file_to_rotate = "/var/log/cream/accounting/blahp.log"
  
  file { "/etc/logrotate.d/blahp-logrotate":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => '0644',
    content => template("creamce/blahp-logrotate.erb"),
    tag     => [ "blahconffiles" ],
  }
  
  unless $use_blparser {
  
    file { "/etc/logrotate.d/bnotifier-logrotate":
      ensure  => present,
      content => template("creamce/bnotifier-logrotate.erb"),
      owner   => "root",
      group   => "root",
      mode    => '0644',
      tag     => [ "blahconffiles" ],
    }

    file { "/etc/logrotate.d/bupdater-logrotate":
      ensure  => present,
      content => template("creamce/bupdater-logrotate.erb"),
      owner   => "root",
      group   => "root",
      mode    => '0644',
      tag     => [ "blahconffiles" ],
    }
  
  }
  
  Package <| tag == 'tomcatcefiles' |> -> File <| tag == 'blahconffiles' |>

  # ##################################################################################################
  # Service management
  # ##################################################################################################

  @service { "glite-ce-blah-parser":
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => Package["${blah_package}"],
    tag        => [ "blahparserservice" ],
  }

  if $::operatingsystem == "CentOS" and $::operatingsystemmajrelease in [ "7" ] {

    file { "/etc/systemd/system/glite-ce-blah-parser.service.d":
      ensure => directory,
      owner  => "root",
      group  => "root",
      mode   => '0644',
    }
    
    file { "/etc/systemd/system/glite-ce-blah-parser.service.d/10-glite-services.conf":
      ensure  => present,
      owner   => "root",
      group   => "root",
      mode    => '0644',
      content => "[Unit]
PartOf=glite-services.target
",
      require => File["/etc/systemd/system/glite-ce-blah-parser.service.d"],
      tag     => [ "glitesystemdfiles" ],
    }

  }

}
