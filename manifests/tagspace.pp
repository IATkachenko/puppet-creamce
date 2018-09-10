define creamce::tagspace ($pub_dir, $a_owner, $a_group) {

  file { "${pub_dir}/${title}":
    ensure  => directory,
    owner   => "${a_owner}",
    group   => "${a_group}",
    mode    => '0755',
  }

  file { "${pub_dir}/${title}/${title}.list":
    ensure  => file,
    owner   => "${a_owner}",
    group   => "${a_group}",
    mode    => '0644',
    require => File["${pub_dir}/${title}"],
  }

}


