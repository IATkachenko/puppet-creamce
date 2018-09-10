require 'gridutils'

module Puppet::Parser::Functions
  newfunction(:build_sb_definitions, :type => :rvalue, :doc => "This function converts sandbox table structure") do | args |
    voenv = args[0]
    sb_path = args[1]

    result = Hash.new

    voenv.each do | voname, vodata |
      vodata[Gridutils::GROUPS_T].each do | group, gdata |
        result["#{sb_path}/#{group}"] = {
          'ensure'    => "directory",
          'owner'     => "tomcat",
          'group'     => group,
          'mode'      => '0770',
          'tag'       => [ 'creamce::sandboxdirs' ],
        }
      end
    end

    return result

  end
end

