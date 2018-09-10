define creamce::slurmtopaccount ($acct) {
  
  exec { "${title}":
    command => "/usr/bin/sacctmgr -i create account name=${acct} description=\"VO ${acct}\" organization=grid",
    unless  => "/usr/bin/sacctmgr -p -n show account ${acct} | grep ${acct}",
  }

}


