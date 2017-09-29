module Gridutils

  GROUPS_T =           'groups'
  GROUPS_GID_T =       'gid'
  GROUPS_FQAN_T =      'fqan'
  GROUPS_PADMIN_T =    'pub_admin'

  USERS_T =            'users'
  USERS_FQAN_T =       'fqan'
  USERS_PSIZE_T =      'pool_size'
  USERS_CRUSR_T =      'create_user'
  USERS_IDLIST_T =     'uid_list'
  USERS_UTABLE_T =     'users_table'
  USERS_NPATTERN_T =   'name_pattern'
  USERS_FIRSTID_T =    'first_uid'
  USERS_NOFFSET_T =    'name_offset'
  USERS_HOMEDIR_T =    'homedir'
  USERS_SHELL_T =      'shell'
  USERS_CPATTERN_T =   'comment_pattern'
  USERS_ACCTS_T =      'accounts'
  
  QUEUES_GROUPS_T =    'groups'
  
  VO_SERVERS_T =       'servers'
  VO_SRVNAME_T =       'server'
  VO_SRVPORT_T =       'port'
  VO_SRVDN_T =         'dn'
  VO_SRVCADN_T =       'ca_dn'
  VO_GTVER_T =         'gt_version'
  
  CE_PHYCPU_T =        'ce_physcpu'
  CE_LOGCPU_T =        'ce_logcpu'
  CE_NODES_T =         'nodes'
  CE_RTENV_T =         'ce_runtimeenv'
  CE_CPUMODEL_T =      'ce_cpu_model'
  CE_CPUSPEED_T =      'ce_cpu_speed'
  CE_CPUVEND_T =       'ce_cpu_vendor'
  CE_CPUVER_T =        'ce_cpu_version'
  CE_INCONN_T =        'ce_inboundip'
  CE_OUTCONN_T =       'ce_outboundip'
  CE_PHYMEM_T =        'ce_minphysmem'
  CE_VIRTMEM_T =       'ce_minvirtmem'
  CE_OSFAMILY_T =      'ce_os_family'
  CE_OSNAME_T =        'ce_os_name'
  CE_OSARCH_T =        'ce_os_arch'
  CE_OSREL_T =         'ce_os_release'
  CE_OTHERD_T =        'ce_otherdescr'
  CE_TMPDIR_T =        'subcluster_tmpdir'
  CE_WNTMDIR_T =       'subcluster_wntmdir'
  CE_BENCHM_T =        'ce_benchmarks'
  CE_ACCELER_T =       'accelerators'
  
  BENCH_SPECFP_D =     'specfp2000'
  BENCH_SPECINT_D =    'specint2000'
  BENCH_HEP_D =        'hep-spec06'

  def Gridutils.norm_fqan(fqan)
    norm_fqan = fqan.lstrip
    norm_fqan.slice!(/\/capability=null/i)
    norm_fqan.slice!(/\/role=null/i)
    norm_fqan.gsub!(/role=/i, "Role=")
    norm_fqan
  end
  
  def Gridutils.get_fqan_table(vodata)

    f_table = Hash.new

    vodata[Gridutils::GROUPS_T].each do | group, gdata |
      gdata[Gridutils::GROUPS_FQAN_T].each do | fqan |

        norm_fqan = Gridutils.norm_fqan(fqan)

        if f_table.has_key?(norm_fqan)
          raise "Duplicate definition of #{norm_fqan} for group #{group}"
        else
          f_table[norm_fqan] = group
        end

      end
    end

    f_table

  end

end
