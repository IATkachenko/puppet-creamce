class creamce::firewall inherits creamce::params {

  if $cream_config_firewall {

    firewall { '101 allow gridftp port':
      proto  => 'tcp',
      dport  => $gridftp_port,
      action => 'accept',
    }

    firewall { '101 allow creamce web application':
      proto  => 'tcp',
      dport  => $ce_port,
      action => 'accept',
    }

    firewall { '101 allow creamce admin tomcat ports':
      proto  => 'tcp',
      dport  => '8005',
      action => 'accept',
    }

    firewall { '102 allow creamce admin tomcat ports':
      proto  => 'tcp',
      dport  => '8009',
      action => 'accept',
    }

    firewall { '101 allow creamce LRMS_EVENT_LISTENER_PORT':
      proto  => 'tcp',
      dport  => '9091',
      action => 'accept',
    }

    firewall { '101 allow creamce sensor port':
      proto  => 'tcp',
      dport  => '9909',
      action => 'accept',
    }

    firewall { '101 allow creamce LB local logger':
      proto  => 'tcp',
      dport  => '9000',
      action => 'accept',
    }

    firewall { '102 allow creamce LB local logger ':
      proto  => 'tcp',
      dport  => '9001-9002',
      action => 'accept',
    }

    firewall { '103 allow grid ftp port range ':
      proto  => 'tcp',
      dport  => '20000-25000',
      action => 'accept',
    }

  }

}
