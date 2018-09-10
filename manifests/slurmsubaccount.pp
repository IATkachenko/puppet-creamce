define creamce::slurmsubaccount ($acct, $p_acct) {

  exec { "${title}":
    command => "/usr/bin/sacctmgr -i create account name=${acct} parent=${p_acct} description=\"VO Group ${acct}\" organization=grid",
    unless  => "/usr/bin/sacctmgr -p -n show account ${acct} | grep ${acct}",
  }
  
}


