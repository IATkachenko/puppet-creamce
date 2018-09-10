define creamce::slurmuser ($pool_user, $accounts, $partitions) {

  $partstr = join($partitions, ",")
  $acctstr = join($accounts, ",")

  exec { "${title}":
    command => "/usr/bin/sacctmgr -i create user name=${pool_user} account=${acctstr} partition=${partstr}",
    unless  => "/usr/bin/sacctmgr -p -n show user ${pool_user} | grep ${pool_user}",
  }
  
}


