class creamce::params {
  $sitename                  = lookup({'name' => "creamce::site::name", 'default_value' => "${::fqdn}"})
  $siteemail                 = lookup({'name' => "creamce::site::email", 'default_value' => ""})
  $ce_host                   = lookup({'name' => "creamce::host", 'default_value' => "${::fqdn}"})
  $ce_port                   = lookup({'name' => 'creamce::port', 'default_value' => 8443})
  $ce_type                   = lookup({'name' => 'creamce::type', 'default_value' => "cream"})
  $ce_quality_level          = lookup({'name' => 'creamce::quality_level', 'default_value' => "production"})
  $ce_env                    = lookup({'name' => 'creamce::environment', 'default_value' => {}})
  $access_by_domain          = lookup({'name' => "creamce::mysql::access_by_domain", 'default_value' => false})
  
  $mysql_override_options    = lookup({'name' => "creamce::mysql::override_options", 
                                 'default_value' => {
                                   'mysqld' => {
                                     'bind-address' => '0.0.0.0',
                                     'max_connections' => "450"
                                   }
                                 }
                               })
  $mysql_password            = lookup("creamce::mysql::root_password")
  $cream_db_max_active       = lookup({'name' => "creamce::mysql::max_active", 'default_value' => 200})
  $cream_db_min_idle         = lookup({'name' => "creamce::mysql::min_idle", 'default_value' => 30})
  $cream_db_max_wait         = lookup({'name' => "creamce::mysql::max_wait", 'default_value' => 10000})
  $cream_db_name             = lookup({'name' => "creamce::creamdb::name", 'default_value' => "creamdb"})
  $cream_db_user             = lookup({'name' => "creamce::creamdb::user", 'default_value' => "cream"})
  $cream_db_password         = lookup("creamce::creamdb::password")
  $cream_db_host             = lookup({'name' => "creamce::creamdb::host", 'default_value' => "${::fqdn}"})
  $cream_db_port             = lookup({'name' => "creamce::creamdb::port", 'default_value' => 3306})
  $cream_db_domain           = lookup({'name' => "creamce::creamdb::domain", 'default_value' => "${::domain}"})
  $cream_db_minpriv_user     = lookup({'name' => "creamce::creamdb::minpriv_user", 'default_value' => "minprivuser"})
  $cream_db_minpriv_password = lookup("creamce::creamdb::minpriv_password")
  $delegation_db_name        = lookup({'name' => "creamce::delegationdb::name", 'default_value' => "delegationcreamdb"})

  $cream_db_sandbox_path     = lookup({'name' => "creamce::sandbox_path", 'default_value' => "/var/cream_sandbox"})
  $cream_enable_limiter      = lookup({'name' => "creamce::enable_limiter", 'default_value' => true})
  $cream_limit_load1         = lookup({'name' => "creamce::limit::load1", 'default_value' => 40})
  $cream_limit_load5         = lookup({'name' => "creamce::limit::load5", 'default_value' => 40})
  $cream_limit_load15        = lookup({'name' => "creamce::limit::load15", 'default_value' => 20})
  $cream_limit_memusage      = lookup({'name' => "creamce::limit::memusage", 'default_value' => 95})
  $cream_limit_swapusage     = lookup({'name' => "creamce::limit::swapusage", 'default_value' => 95})
  $cream_limit_fdnum         = lookup({'name' => "creamce::limit::fdnum", 'default_value' => 500})
  $cream_limit_diskusage     = lookup({'name' => "creamce::limit::diskusage", 'default_value' => 95})
  $cream_limit_ftpconn       = lookup({'name' => "creamce::limit::ftpconn", 'default_value' => 30})
  $cream_limit_fdtomcat      = lookup({'name' => "creamce::limit::fdtomcat", 'default_value' => 800})
  $cream_limit_activejobs    = lookup({'name' => "creamce::limit::activejobs", 'default_value' => -1})
  $cream_limit_pendjobs      = lookup({'name' => "creamce::limit::pendjobs", 'default_value' => -1})
  $cream_queue_size          = lookup({'name' => "creamce::queue_size", 'default_value' => 500})
  $cream_workerpool_size     = lookup({'name' => "creamce::workerpool_size", 'default_value' => 50})
  $cream_blah_timeout        = lookup({'name' => "creamce::blah_timeout", 'default_value' => 300})
  $cream_listener_port       = lookup({'name' => "creamce::listener_port", 'default_value' => 49152})
  $cream_job_purge_rate      = lookup({'name' => "creamce::job::purge_rate", 'default_value' => 300})
  $cream_job_prefix          = lookup({'name' => "creamce::job::prefix", 'default_value' => "cream_"})
  $cream_blp_retry_delay     = lookup({'name' => "creamce::blp::retry_delay", 'default_value' => 60})
  $cream_blp_retry_count     = lookup({'name' => "creamce::blp::retry_count", 'default_value' => 100})
  $cream_lease_time          = lookup({'name' => "creamce::lease::time", 'default_value' => 36000})
  $cream_lease_rate          = lookup({'name' => "creamce::lease::rate", 'default_value' => 30})
  $cream_purge_aborted       = lookup({'name' => "creamce::purge::aborted", 'default_value' => 10})
  $cream_purge_cancel        = lookup({'name' => "creamce::purge::cancel", 'default_value' => 10})
  $cream_purge_done          = lookup({'name' => "creamce::purge::done", 'default_value' => 10})
  $cream_purge_failed        = lookup({'name' => "creamce::purge::failed", 'default_value' => 10})
  $cream_purge_register      = lookup({'name' => "creamce::purge::register", 'default_value' => 2})
  
  $deleg_purge_rate          = lookup({'name' => "creamce::delegation::purge_rate", 'default_value' => 10})
  
  $jw_deleg_time_slot        = lookup({'name' => "creamce::jw::deleg_time_slot", 'default_value' => 3600})
  $jw_proxy_retry_wait       = lookup({'name' => "creamce::jw::proxy_retry_wait", 'default_value' => 60})
  $jw_retry_count_isb        = lookup({'name' => "creamce::jw::isb::retry_count", 'default_value' => 2})
  $jw_retry_wait_isb         = lookup({'name' => "creamce::jw::isb::retry_wait", 'default_value' => 60})
  $jw_retry_count_osb        = lookup({'name' => "creamce::jw::osb::retry_count", 'default_value' => 6})
  $jw_retry_wait_osb         = lookup({'name' => "creamce::jw::osb::retry_wait", 'default_value' => 300})

  $gridenvfile               = lookup({'name' => 'creamce::gridenvfile::sh', 'default_value' => '/etc/profile.d/grid-env.sh'})
  $gridenvcfile              = lookup({'name' => 'creamce::gridenvfile::csh', 'default_value' => '/etc/profile.d/grid-env.csh'})
  
  $cga_logfile               = lookup({'name' => "creamce::cga::logfile", 'default_value' => "/var/log/cleanup-grid-accounts.log"})
  $cga_cron_sched            = lookup({'name' => "creamce::cga::cron_sched", 'default_value' => "30 1 * * *"})
  $at_deny_extras            = lookup({'name' => "creamce::at_deny_extras", 'default_value' => []})
  $cron_deny_extras          = lookup({'name' => "creamce::cron_deny_extras", 'default_value' => []})
  $sudo_logfile              = lookup({'name' => "creamce::sudo_logfile", 'default_value' => ""})
  $default_pool_size         = lookup({'name' => "creamce::default_pool_size", 'default_value' => 100})
  $username_offset           = lookup({'name' => "creamce::username_offset", 'default_value' => 1})
  $create_user               = lookup({'name' => "creamce::create_user", 'default_value' => true})

  #
  # Tomcat
  #
  case $::lsbmajdistrelease {
    "6": {
      $tomcat                = "tomcat6"
    }
    default: {
      $tomcat                = "tomcat"
    }
  }
  $catalina_home             = lookup({'name' => 'creamce::catalina::home', 'default_value' => "/usr/share/$tomcat"})
  $tomcat_server_lib         = lookup({'name' => 'creamce::catalina::server_lib', 'default_value' => "${catalina_home}/lib"})
  $tomcat_cert               = lookup({'name' => 'creamce::tomcat::cert', 'default_value' => '/etc/grid-security/tomcat-cert.pem'})
  $tomcat_key                = lookup({'name' => 'creamce::tomcat::key', 'default_value' => '/etc/grid-security/tomcat-key.pem'})
  $java_opts                 = lookup({'name' => 'creamce::java_opts', 'default_value' => '-Xms512m -Xmx2048m'})

  
  #
  # BLAH/LRMS
  #
  $batch_system              = lookup("creamce::batch_system")
  case $::lsbmajdistrelease {
    "6": {
      $blah_package          = "glite-ce-blahp"
    }
    default: {
      $blah_package          = "BLAH"
    }
  }
  $blah_config_file          = lookup({'name' => "blah::config_file", 'default_value' => "/etc/blah.config"})
  $blah_child_poll_timeout   = lookup({'name' => "blah::child_poll_timeout", 'default_value' => 200})
  $blah_alldone_interval     = lookup({'name' => "blah::alldone_interval", 'default_value' => 86400})
  $blah_shared_dirs          = lookup({'name' => "blah::shared_directories", 'default_value' => []})
  $use_blparser              = lookup({'name' => "blah::use_blparser", 'default_value' => false})
  $blah_blp_server           = lookup({'name' => "blah::blp::host", 'default_value' => ""})
  $blah_blp_port             = lookup({'name' => "blah::blp::port", 'default_value' => 33333})
  $blah_blp_num              = lookup({'name' => "blah::blp::num", 'default_value' => 1})
  $blah_blp_server1          = lookup({'name' => "blah::blp::host1", 'default_value' => "${blah_blp_server}"})
  $blah_blp_port1            = lookup({'name' => "blah::blp::port1", 'default_value' => 33334})
  $blah_blp_server2          = lookup({'name' => "blah::blp::host2", 'default_value' => "${blah_blp_server}"})
  $blah_blp_port2            = lookup({'name' => "blah::blp::port2", 'default_value' => 33335})
  $blah_blp_cream_port       = lookup({'name' => "blah::blp::cream_port", 'default_value' => 56565})
  $blah_check_children       = lookup({'name' => "blah::check_children", 'default_value' => 30})
  $blah_logrotate_interval   = lookup({'name' => "blah::logrotate::interval", 'default_value' => 365})
  $blah_logrotate_size       = lookup({'name' => "blah::logrotate::size", 'default_value' => "10M"})
  $bupdater_loop_interval    = lookup({'name' => "blah::bupdater::loop_interval", 'default_value' => 30})
  $bupdater_notify_port      = lookup({'name' => "blah::bupdater::notify_port", 'default_value' => 56554})
  $bupdater_purge_interval   = lookup({'name' => "blah::bupdater::purge_interval", 'default_value' => 2500000})
  $bupdater_logrot_interval  = lookup({'name' => "blah::bupdater::logrotate::interval", 'default_value' => 50})
  $bupdater_logrot_size      = lookup({'name' => "blah::bupdater::logrotate::size", 'default_value' => "10M"})
  
  $torque_config_client      = lookup({'name' => "torque::config::client", 'default_value' => true})
  $torque_config_pool        = lookup({'name' => "torque::config::pool", 'default_value' => true})
  $torque_server             = lookup({'name' => "torque::host", 'default_value' => "${::fqdn}"})
  $torque_log_dir            = lookup({'name' => "torque::log_dir", 'default_value' => "/var/lib/torque/"})
  $torque_multiple_staging   = lookup({'name' => "torque::multiple_staging", 'default_value' => false})
  $torque_tracejob_logs      = lookup({'name' => "torque::tracejob_logs", 'default_value' => 2})
  $torque_use_maui           = lookup({'name' => "torque::use_maui", 'default_value' => false})
  $torque_sched_opts         = lookup({'name' => "torque::sched_opts", 'default_value' => { "cycle_time" => "0" }})
  $torque_caching_filter     = lookup({'name' => "torque::command_caching_filter", 'default_value' => ""})
  $munge_key_path            = lookup({'name' => "munge::key_path", 'default_value' => ""})

  $lsf_primary_master        = lookup({'name' => "lsf::primary_master", 'default_value' => undef})
  $lsf_secondary_master      = lookup({'name' => "lsf::secondary_master", 'default_value' => undef})
  $lsf_exec_path             = lookup({'name' => "lsf::executable_path", 'default_value' => "/usr/bin"})
  $lsf_etc_path              = lookup({'name' => "lsf::config_path", 'default_value' => "/etc"})
  $lsf_report_group          = lookup({'name' => "lsf::reporting_group", 'default_value' => "GID"})
  $lsf_caching_filter        = lookup({'name' => "lsf::command_caching_filter", 'default_value' => ""})
  $lsf_conf_afs_path         = lookup({'name' => "lsf::conf_afs_path", 'default_value' => undef})
  $lsf_config_batchacct      = lookup({'name' => "lsf::config::batchacct", 'default_value' => false})
  $lsf_batch_caching         = lookup({'name' => "lsf::batch::caching", 'default_value' => false})
  $lsf_use_cache             = lookup({'name' => "lsf::cache::enabled", 'default_value' => true})
  $lsf_cache_path            = lookup({'name' => "lsf::cache::path", 'default_value' => "/var/cache/info-dynamic-lsf"})
  $lsf_cache_default_t       = lookup({'name' => "lsf::cache::time::default", 'default_value' => 300})
  $lsf_cache_bugroups_t      = lookup({'name' => "lsf::cache::time::bugroups", 'default_value' => 18000})
  $lsf_cache_lshosts_t       = lookup({'name' => "lsf::cache::time::lshosts", 'default_value' => 18000})
  $lsf_cache_lsid_t          = lookup({'name' => "lsf::cache::time::lsid", 'default_value' => 3600})
  $lsf_cache_bqueues_t       = lookup({'name' => "lsf::cache::time::bqueues", 'default_value' => 180})
  $lsf_cache_bhosts_t        = lookup({'name' => "lsf::cache::time::bhosts", 'default_value' => 10800})
  $lsf_cache_bhostsinfo_t    = lookup({'name' => "lsf::cache::time::bhostsinfo", 'default_value' => 10800})
  $lsf_cache_bmgroup_t       = lookup({'name' => "lsf::cache::time::bmgroup", 'default_value' => 10800})
  $lsf_cache_bjobs_t         = lookup({'name' => "lsf::cache::time::bjobs", 'default_value' => 180})
  $lsf_cache_bjobsinfo_t     = lookup({'name' => "lsf::cache::time::bjobsinfo", 'default_value' => 180})
  $lsf_cache_blimits_t       = lookup({'name' => "lsf::cache::time::blimits", 'default_value' => 10800})
  $lsf_cache_bhist_t         = lookup({'name' => "lsf::cache::time::bhist", 'default_value' => 300})
  $lsf_profile_filepath      = lookup({'name' => "lsf::profile::file_path", 'default_value' => "/etc/profile.lsf"})
  $lsf_btools_path           = lookup({'name' => "lsf::btools::path", 'default_value' => ""})

  $slurm_master              = lookup({'name' => "slurm::master_host", 'default_value' => "${::fqdn}"})
  $slurm_sched_opts          = lookup({'name' => "slurm::sched_opts", 'default_value' => { "cycle_time" => "0" }})
  $slurm_caching_filter      = lookup({'name' => "slurm::command_caching_filter", 'default_value' => ""})
  $slurm_config_acct         = lookup({'name' => "slurm::config_accounting", 'default_value' => false})
  $slurm_use_std_acct        = lookup({'name' => "slurm::standard_accounts", 'default_value' => false})
  
  $condor_sched_opts         = lookup({'name' => "condor::sched_opts", 'default_value' => { "cycle_time" => "0" }})
  $condor_caching_filter     = lookup({'name' => "condor::command_caching_filter", 'default_value' => ""})
  $condor_user_history       = lookup({'name' => "condor::use_history", 'default_value' => false})
  $condor_deploy_mode        = lookup({'name' => "condor::deployment_mode", 'default_value' => "queue_to_schedd"})
  $condor_queue_attr         = lookup({'name' => "condor::queue_attribute", 'default_value' => undef})
  $condor_conf_dir           = lookup({'name' => "condor::config::dir", 'default_value' => "/etc/condor/config.d"})

  $sge_master                = lookup({'name' => "gridengine::master", 'default_value' => "${::fqdn}"})
  $sge_master_port           = lookup({'name' => "gridengine::master_port", 'default_value' => 536})
  $sge_execd_port            = lookup({'name' => "gridengine::execd_port", 'default_value' => 537})
  $sge_root_path             = lookup({'name' => "gridengine::root_path", 'default_value' => "/opt/sge"})
  $sge_cell                  = lookup({'name' => "gridengine::cell", 'default_value' => "default"})
  $sge_spool_meth            = lookup({'name' => "gridengine::spool_meth", 'default_value' => "classic"})
  $sge_spool_dir             = lookup({'name' => "gridengine::spool_dir", 'default_value' => "${sge_root_path}/default/common"})
  $sge_bin_dir               = lookup({'name' => "gridengine::bin_dir", 'default_value' => "${sge_root_path}/bin"})
  $sge_cluster               = lookup({'name' => "gridengine::cluster_name", 'default_value' => undef})

  $cream_config_ssh          = lookup({'name' => "creamce::config_ssh", 'default_value' => false})
  $shosts_equiv_extras       = lookup({'name' => "creamce::shosts_equiv_extras", 'default_value' => []})
  $ssh_cron_sched            = lookup({'name' => "creamce::ssh_cron_sched", 'default_value' => "05 1,7,13,19 * * *"})
  
  $cream_config_sudo                 = lookup({'name' => 'creamce::config_sudo', 'default_value' => true})
  $cream_config_sudo_install_package = lookup({'name' => 'creamce::config_sudo_install_package', 'default_value' => true})
  $cream_config_firewall     = lookup({'name' => 'creamce::config_firewall', 'default_value' => true})

  #
  # LCAS/LCMAPS/GLEXEC
  #
  $lcas_log_level          = lookup({'name' => 'lcas::log_level', 'default_value' => 1})
  $lcas_debug_level        = lookup({'name' => 'lcas::debug_level', 'default_value' => 0})
  $lcmaps_log_level        = lookup({'name' => 'lcmaps::log_level', 'default_value' => 1})
  $lcmaps_debug_level      = lookup({'name' => 'lcmaps::debug_level', 'default_value' => 0})
  $lcmaps_rotate_size      = lookup({'name' => "lcmaps::rotate::size", 'default_value' => "10M"})
  $lcmaps_rotate_num       = lookup({'name' => "lcmaps::rotate::num", 'default_value' => 50})
  $glexec_rotate_size      = lookup({'name' => "glexec::rotate::size", 'default_value' => "10M"})
  $glexec_rotate_num       = lookup({'name' => "glexec::rotate::num", 'default_value' => 50})
  $glexec_log_file         = lookup({'name' => "glexec::log_file", 'default_value' => ""})
  $glexec_log_level        = lookup({'name' => "glexec::log_level", 'default_value' => 1})
  $glexec_ll_log_file      = lookup({'name' => "glexec::low_level_log_file", 'default_value' => "/var/log/glexec/lcas_lcmaps.log"})
  
  #
  # GridFTP
  #
  $gridftp_host              = lookup({'name' => "gridftp::params::hostname", 'default_value' => "${::fqdn}"})
  $gridftp_port              = lookup({'name' => "gridftp::params::port", 'default_value' => 2811})
  $gridft_pub_dir            = lookup({'name' => 'gridftp_pub_dir', 'default_value' => '/var/info'})
  $globus_tcp_port_range     = lookup({'name' => "gridftp::params::globus_tcp_port_range", 'default_value' => "20000,25000"})
  $globus_udp_port_range     = lookup({'name' => "gridftp::params::globus_udp_port_range", 'default_value' => undef})
  $gridftp_configfile        = lookup({'name' => "gridftp::params::configfile", 'default_value' => "/etc/gridftp.conf"})
  $gridftp_configdir         = lookup({'name' => "gridftp::params::configdir", 'default_value' => "/etc/gridftp.d"})
  $gridftp_thread_model      = lookup({'name' => "gridftp::params::thread_model", 'default_value' => undef})
  $gridftp_force_tls         = lookup({'name' => "gridftp::params::force_tls", 'default_value' => 1})
  $gridftp_extra_vars        = lookup({'name' => "gridftp_extra_vars", 'default_value' => {}})
  
  #
  # Security
  #
  $pki_support             = lookup({'name' => 'creamce::pki_support', 'default_value' => true})
  $host_certificate        = lookup({'name' => 'creamce::host_certificate', 'default_value' => '/etc/grid-security/hostcert.pem'})
  $host_private_key        = lookup({'name' => 'creamce::host_private_key', 'default_value' => '/etc/grid-security/hostkey.pem'})
  $cacert_dir              = lookup({'name' => 'creamce::cacert_dir', 'default_value' => '/etc/grid-security/certificates'})
  $voms_dir                = lookup({'name' => 'creamce::voms_dir', 'default_value' => '/etc/grid-security/vomsdir'})
  $gridmap_dir             = lookup({'name' => 'creamce::gridmap_dir', 'default_value' => '/etc/grid-security/gridmapdir'})
  $gridmap_file            = lookup({'name' => 'creamce::gridmap_file', 'default_value' => '/etc/grid-security/grid-mapfile'})
  $gridmap_extras          = lookup({'name' => "creamce::gridmap_extras", 'default_value' => []})
  $gridmap_cron_sched      = lookup({'name' => "creamce::gridmap_cron_sched", 'default_value' => "5 * * * *"})
  $groupmap_file           = lookup({'name' => 'creamce::groupmap_file', 'default_value' => '/etc/grid-security/groupmapfile'})
  $groupmap                = lookup({'name' => 'creamce::groupmap', 'default_value' => undef})
  $crl_update_time         = lookup({'name' => 'creamce::crl_update_time', 'default_value' => 3600})
  $cream_ban_list_file     = lookup({'name' => 'creamce::ban_list_file', 'default_value' => '/etc/lcas/ban_users.db'})
  $cream_ban_list          = lookup({'name' => 'creamce::ban_list', 'default_value' => undef}) 
  $use_argus               = lookup({'name' => "creamce::use_argus", 'default_value' => true})
  $argusservice            = lookup({'name' => "creamce::argus::service", 'default_value' => undef})
  $argusport               = lookup({'name' => "creamce::argus::port", 'default_value' => 8154})
  $argus_timeout           = lookup({'name' => "creamce::argus::timeout", 'default_value' => 30})
  $cream_pepc_resourceid   = lookup({'name' => 'creamce::argus::resourceid', 'default_value' => "https://${ce_host}:${ce_port}/cream"})
  $admin_list              = lookup({'name' => 'creamce::admin::list', 'default_value' => []})
  $cream_admin_list_file   = lookup({'name' => 'creamce::admin::list_file', 'default_value' => '/etc/grid-security/admin-list'})
  $voenv                   = lookup({'name' => 'creamce::vo_table', 'default_value' => {}})


  #
  # Infosystem
  #
  $info_user               = lookup({'name' => "bdii::params::user", 'default_value' => "ldap"})
  $info_group              = lookup({'name' => "bdii::params::group", 'default_value' => "ldap"})
  $info_port               = lookup({'name' => 'bdii::params::port', 'default_value' => 2170})
  $slapdconf               = lookup({'name' => 'bdii::params::slapdconf', 'default_value' => '/etc/bdii/bdii-slapd.conf'})
  $info_log_level          = lookup({'name' => 'bdii::params::log_level', 'default_value' => 'DEBUG'})
  $info_delete_delay       = lookup({'name' => 'bdii::params::deletedelay', 'default_value' => '0'})
  $slapdthreads            = lookup({'name' => 'bdii::params::slapdthreads', 'default_value' => '16'})
  $slapdloglevel           = lookup({'name' => 'bdii::params::slapdloglevel', 'default_value' => '0'})
  $subclusters             = lookup({'name' => 'creamce::hardware_table', 'default_value' => {}})
  $clustermode             = lookup({'name' => 'creamce::cluster_mode', 'default_value' => false})
  $glue_2_1                = lookup({'name' => 'creamce::info::glue21_draft', 'default_value' => false})
  $gippath                 = lookup({'name' => 'creamce::info::gip_path', 'default_value' => "/var/lib/bdii/gip"})
  $info_type               = lookup({'name' => 'creamce::info::type', 'default_value' => "resource"})
  $ce_capability           = lookup({'name' => 'creamce::info::capability', 'default_value' => []})
  $computing_service_id    = lookup({'name' => 'creamce::info::service_id', 'default_value' => "${ce_host}_ComputingElement"})
  $se_list                 = lookup({'name' => 'creamce::se_table', 'default_value' => {}})
  $grid_queues             = lookup({'name' => 'creamce::queues', 'default_value' => {}})
  $vo_soft_dir             = lookup({'name' => 'creamce::vo_software_dir', 'default_value' => ""})
  $workarea_shared         = lookup({'name' => 'creamce::workarea::shared', 'default_value' => false})
  $workarea_guaranteed     = lookup({'name' => 'creamce::workarea::guaranteed', 'default_value' => false})
  $workarea_total          = lookup({'name' => 'creamce::workarea::total', 'default_value' => 0})
  $workarea_free           = lookup({'name' => 'creamce::workarea::free', 'default_value' => 0})
  $workarea_lifetime       = lookup({'name' => 'creamce::workarea::lifetime', 'default_value' => 0})
  $workarea_mslot_total    = lookup({'name' => 'creamce::workarea::mslot_total', 'default_value' => 0})
  $workarea_mslot_free     = lookup({'name' => 'creamce::workarea::mslot_free', 'default_value' => 0})
  $workarea_mslot_lifetime = lookup({'name' => 'creamce::workarea::mslot_lifetime', 'default_value' => 0})
  $applications            = lookup({'name' => 'creamce::software_table', 'default_value' => {}})
  
  #
  # Locallogger
  #
  $use_loclog                 = lookup({'name' => 'creamce::use_locallogger', 'default_value' => false})
  $loclog_user                = lookup({'name' => 'locallogger::user', 'default_value' => 'glite'})
  $loclog_group               = lookup({'name' => 'locallogger::group', 'default_value' => 'glite'})
  $loclog_dir                 = lookup({'name' => 'locallogger::dir', 'default_value' => '/var/lib/glite'})

  #
  # apel accounting secrets
  #
  $use_apel                   = lookup({'name' => 'apel::use_apel', 'default_value' => false})
  $apel_dbname                = lookup({'name' => 'apel::db::name', 'default_value' => 'apelclient'})
  $apel_dbuser                = lookup({'name' => 'apel::db::user', 'default_value' => 'apel'})
  $apel_dbpass                = lookup({'name' => 'apel::db::pass', 'default_value' => ""})
  $apel_dbhost                = lookup({'name' => 'apel::db::host', 'default_value' => 'localhost'})
  $apel_dbport                = lookup({'name' => 'apel::db::port', 'default_value' => 3306})
  $apel_parallel              = lookup({'name' => 'apel::parallel', 'default_value' => false})
  $apel_lrms_dir              = lookup({'name' => 'apel::batch::dir', 'default_value' => ""})
  $apel_file_prefix           = lookup({'name' => 'apel::prefix::filter', 'default_value' => ""})
  $apel_cron_sched            = lookup({'name' => 'apel::cron::sched', 'default_value' => "5 0 * * *"})
  case $batch_system {
    condor: {
      $apel_lrms_srv          = "${ce_host}"
    }
    lsf: {
      $apel_lrms_srv          = "${lsf_primary_master}"
    }
    pbs: {
      $apel_lrms_srv          = "${torque_server}"
    }
    slurm: {
      $apel_lrms_srv          = "${slurm_master}"
    }
    sge: {
      $apel_lrms_srv          = "${sge_master}"
    }
    default: {
      $apel_lrms_srv          = "${ce_host}"
    }
  }

  #
  # yum repositories
  #
  $cream_repo_urls            = lookup({'name' => 'creamce::repo_urls', 'default_value' => []})
  $cream_rpmkey_urls          = lookup({'name' => 'creamce::rpm_key_urls', 'default_value' => []})

}
