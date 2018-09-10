class creamce::gridftp inherits creamce::params {

  require creamce::certificate
  
  if $use_argus {
    $gridftp_auth_plugin = "argus-gsi-pep-callout"
  } else {
    $gridftp_auth_plugin = "lcas-lcmaps-gt4-interface"
    require creamce::lcmaps
  }
  
  class{ "gridftp::install":}
  
  class{ "gridftp::service":}
  
  class{ "gridftp::config":
    require => Package["globus-proxy-utils", "kill-stale-ftp", "${gridftp_auth_plugin}"],
    notify  => Class["Gridftp::Service"],
  }
  
  if $use_argus {
  
    # Documentation: https://twiki.cern.ch/twiki/bin/view/EGEE/AuthZPEPGSIConfig
    file { "/etc/grid-security/gsi-authz.conf":
      ensure  => file,
      owner   => "root",
      group   => "root",
      mode    => '0644',
      content => "globus_mapping /usr/lib64/libgsi_pep_callout.so argus_pep_callout\n",
      require => Class["Gridftp::Config"],
      notify  => Class["Gridftp::Service"],
    }
  
    file { "/etc/grid-security/gsi-pep-callout.conf":
      ensure  => file,
      owner   => "root",
      group   => "root",
      mode    => '0644',
      content => template("creamce/gsi-pep-callout.conf.erb"),
      require => Class["Gridftp::Config"],
      notify  => Class["Gridftp::Service"],
    }

  } else {

    # workaround for lcas/lcmaps log level setup
    File <| title == '/etc/sysconfig/globus-gridftp-server' |> {
      content => template("creamce/gridftp-sysconfig.erb"),
    }

    file { "/etc/grid-security/gsi-authz.conf":
      ensure  => file,
      owner   => "root",
      group   => "root",
      mode    => '0644',
      content => "globus_mapping /usr/lib64/liblcas_lcmaps_gt4_mapping.so lcmaps_callout\n",
      require => Class["Gridftp::Config"],
      notify  => Class["Gridftp::Service"],
    }

  }
  
  package { ["globus-proxy-utils", "kill-stale-ftp", "${gridftp_auth_plugin}"]:
    ensure  => present,
    require => Class["Gridftp::Install"],
    tag     => [ "gridftppackages", "umdpackages" ],
  }
  
}
