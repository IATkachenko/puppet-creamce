define creamce::vofiles ($server, $port, $dn, $ca_dn, $gtversion, $voname, $vodir) {

  $lscfile_content = "${dn}\n${ca_dn}\n"
  file { "${vodir}/${voname}/${server}.lsc":
    ensure  => file,
    owner   => "root",
    group   => "root",
    mode    => '0644',
    content => "${lscfile_content}",
    require => File["${vodir}/${voname}"],
    tag     => [ "vomscefiles" ],
  }
  
  # maybe we can use the voname for nickname
  $nickname = $title
  
  $vomsfile_content = "\"${nickname}\" \"${server}\" \"${port}\" \"${dn}\" \"${voname}\" \"${gtversion}\"\n"
  file { "/etc/vomses/${voname}-${server}":
    ensure  => file,
    owner   => "root",
    group   => "root",
    mode    => '0644',
    content => "${vomsfile_content}",
    require => File["/etc/vomses"],
    tag     => [ "vomscefiles" ],
  }    
  
}


