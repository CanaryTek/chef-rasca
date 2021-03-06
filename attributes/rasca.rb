##
## Attributes for modularit
##

# Rasca node name
default['rasca']['node_name']=Chef::Config[:node_name]
default['nagios_name']=Chef::Config[:node_name]

# Gem repo and version to install
default['rasca']['gemrepo']="http://gems.canarytek.com/"
default['rasca']['gem_version']="0.1.31"

# Packages
case node['platform_family']
when 'debian'
  default['rasca']['packages'] = [ "ruby", "rubygems", "git", "lsof", "lvm2" ]
when 'suse'
  default['rasca']['packages'] = [ "ruby", "rubygems", "git", "cronie", "lsof" ]
when 'rhel', 'fedora'
  default['rasca']['packages'] = [ "ruby", "rubygems", "git", "crontabs", "lsof" ]
else
  default['rasca']['packages'] = [ "ruby", "rubygems", "git", "crontabs", "lsof" ]
end

# ModularIT directories
default['rasca']['alarmdir']="/var/lib/modularit/alarms"
default['rasca']['objdir']="/var/lib/modularit/obj"
default['rasca']['confdir']="/etc/modularit"

## Notifications
default['rasca']['nagios_server']="nagios.example.local"
# Send notifications when check status is at least this level
default['rasca']['notify_level']="CORRECTED"
# Reminder period in seconds. To avoid sending notifications too often
default['rasca']['remind_period']=3*60*60

