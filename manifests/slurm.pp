class creamce::slurm inherits creamce::params {

  include creamce::blah
  include creamce::gip
  
  $vo_group_table = build_vo_group_table($voenv)
  
  # ##################################################################################################
  # BLAHP setup
  # ##################################################################################################

  file{"${blah_config_file}":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => '0644',
    content => template("creamce/blah.config.slurm.erb"),
    tag     => [ "blahconffiles" ],
  }

  # realization of virtual resource Service["glite-ce-blah-parser"]
  File <| tag == 'blahconffiles' |> ~> Service <| tag == 'blahparserservice' |>

  # ##################################################################################################
  # SLURM infoproviders
  # ##################################################################################################

  package{"info-dynamic-scheduler-slurm":
    ensure  => present,
    require => Package["dynsched-generic"],
    tag     => [ "bdiipackages", "umdpackages" ],
  }

  file { "/etc/lrms/scheduler.conf":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => '0644',
    content => template("creamce/gip/slurm-provider.conf.erb"),
    require => Package["info-dynamic-scheduler-slurm"],
    notify  => Service["bdii"],
  }

  # ##################################################################################################
  # SLURM client
  # ##################################################################################################
  
  if $cream_config_ssh {
    
    class { 'creamce::sshconfig':
      lrms_host_script => "/usr/bin/scontrol -o show nodes | grep -Eo 'NodeHostName=(\\S+)' | cut -d \"=\" -f 2",
      lrms_master_node => $slurm_master
    }

  }

  if $slurm_config_acct {

    include creamce::poolaccount

    $slurm_acct_users = build_slurm_users($voenv, $grid_queues,
                                          $default_pool_size, $slurm_use_std_acct, $username_offset)
    create_resources(creamce::slurmuser, $slurm_acct_users)

    if $slurm_use_std_acct {

      $top_slurm_accts = build_slurm_accts($voenv, "top")
      create_resources(creamce::slurmtopaccount, $top_slurm_accts)

      $sub_slurm_accts = build_slurm_accts($voenv, "sub")
      create_resources(creamce::slurmsubaccount, $sub_slurm_accts)
      
      Creamce::Pooluser <| |> -> Creamce::Slurmtopaccount <| |>
      Creamce::Slurmtopaccount <| |> -> Creamce::Slurmsubaccount <| |>
      Creamce::Slurmsubaccount <| |> -> Creamce::Slurmuser <| |>

    }

  }

}
