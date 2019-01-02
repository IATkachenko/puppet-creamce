class creamce::certificate inherits creamce::params {

  if $pki_support {

    class { "fetchcrl":
      runboot => false,
      runcron => true,
    }
    
    file { "${host_certificate}":
      ensure   => file,
      owner    => "root",
      group    => "root",
      mode     => '0644',
    }

    file { "${host_private_key}":
      ensure   => file,
      owner    => "root",
      group    => "root",
      mode     => '0400',
    }
    
    exec { "initial_fetch_crl":
      command => "/usr/sbin/fetch-crl -l ${cacert_dir} -o ${cacert_dir} || exit 0",
      unless  => "/bin/ls ${cacert_dir}/*.r0",
    }

    Class['fetchcrl'] -> File["${host_certificate}", "${host_private_key}"]
    Class['fetchcrl'] -> Exec["initial_fetch_crl"]

  } else {

    info "PKI support is disabled; host credentials and CA certificates must be installed manually"

  }
  
}
