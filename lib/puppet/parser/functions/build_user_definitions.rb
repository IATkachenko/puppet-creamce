module Puppet::Parser::Functions
  newfunction(:build_user_definitions, :type => :rvalue, :doc => "This function converts user table structure") do | args |
    voenv = args[0]
    gridmapdir = args[1]
    def_pool_size = args[2].to_i()
    def_name_offset = args[3].to_i()
    
    result = Hash.new
    
    voenv.each do | voname, vodata |
      vodata['users'].each do | user_prefix, udata |
      
        home_dir = udata.fetch('homedir', '/home')
        use_shell = udata.fetch('shell', '/bin/bash')
        name_pattern = udata.fetch('name_pattern', '%<prefix>s%03<index>d')
        name_offset = udata.fetch('name_offset', def_name_offset)
        
        utable = udata.fetch('users_table', Hash.new)
        if utable.size > 0
          utable.each do | u_name, u_id |
            result[u_name] = {
              'uid'        => u_id,
              'groups'     => udata['groups'],
              'gridmapdir' => "#{gridmapdir}",
              'homedir'    => "#{home_dir}",
              'shell'      => "#{use_shell}"
            }
          end
          next
        end
        
        uidlist = udata.fetch('uid_list', Array.new)
        if uid_list.size > 0
          (0...uid_list.size).each do | idx |
            nameStr = sprintf(name_pattern % { :prefix => user_prefix, :index => (idx + name_offset) })
            result[u_name] = {
              'uid'        => uidlist.at(idx),
              'groups'     => udata['groups'],
              'gridmapdir' => "#{gridmapdir}",
              'homedir'    => "#{home_dir}",
              'shell'      => "#{use_shell}"
            }
          end
          next
        end

        pool_size = udata.fetch('pool_size', def_pool_size)
        if pool_size > 0
        
          (0...pool_size).each do | idx |
            nameStr = sprintf(name_pattern % { :prefix => user_prefix, :index => (idx + name_offset) })
            result[nameStr] = { 
              'uid'        => udata['first_uid'] + idx,
              'groups'     => udata['groups'],
              'gridmapdir' => "#{gridmapdir}",
              'homedir'    => "#{home_dir}",
              'shell'      => "#{use_shell}"
            }
          
          end
        else
          # static account
          result["#{user_prefix}"] = { 
            'uid'        => udata['first_uid'],
            'groups'     => udata['groups'],
            'gridmapdir' => "#{gridmapdir}",
            'homedir'    => "#{home_dir}",
            'shell'      => "#{use_shell}"
          }
        end
      end
    end
    
    return result

  end
end

