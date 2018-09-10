define creamce::torquemember ($queue, $group) {
    
  exec { "${title}":
    command => "/usr/bin/qmgr -c \"set queue ${queue} acl_groups += ${group}\"",
    unless  => "/usr/bin/qmgr -c \"list queue ${queue} acl_groups\" | awk '/acl_groups/,EOF {print \$NF}'| grep -qwi ${group}",
  }
    
}


