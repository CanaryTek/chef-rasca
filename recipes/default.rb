# Cookbook Name:: modularit
# Recipe:: rasca
#
# Copyright 2013, CanaryTek
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

## FIXME: Ugly hack
@alarmdir=node["rasca"]["alarmdir"]
@objdir=node["rasca"]["objdir"]
@confdir=node["rasca"]["confdir"]

## Needed packages
[ "ruby", "rubygems", "git", "crontabs"].each do |pkg|
  package pkg do
    action :upgrade
  end
end

## Install Gem source if needed
execute "add_rasca_gem_repo" do
  command "gem source -a #{node['rasca']['gemrepo']}"
  not_if {%x[gem sources -l].include? node['rasca']['gemrepo']}
end

## Rasca GEM
gem_package("rasca") do
  version(node["rasca"]["gem_version"])
  action(:install)
end

## Rasca Emergency alarm links
["HostChk", "ProcChk", "DfChk"].each do |check|
  rasca_check check do
    priority "Emergency"
  end
end
## Rasca Warning alarm links
["GitChk"].each do |check|
  rasca_check check do
    priority "Warning"
  end
end

## Basic alarm object files
# ProcChk
rasca_object "ProcChk" do
  check "ProcChk"
  content <<EOF
## Basic processes
# Run alert with option --info to see the format
sshd:
  :ensure: started
  :cmd: /etc/init.d/sshd restart
EOF
end
# GitChk
rasca_object "GitChk" do
  check "GitChk"
  content <<EOF
# Run alert with option --info to see the format
/etc:
  :proactive: :commit
EOF
end

#
## Rasca scheduler
# FIXME: move this to gem 
cookbook_file "/usr/sbin/rasca_scheduler" do
  source "rasca_scheduler"
  owner "root"
  group "root"
  mode 00755
  action :create
end

## Modularit config dir
directory @confdir do
  owner "root"
  group "root"
  mode 00755
  recursive true
  action :create
end

## Rasca config
template "#{@confdir}/rasca.cfg" do
  source "rasca.cfg.erb"
  cookbook "rasca"
  owner "root"
  group "root"
  mode 00644
  action :create
end

## nsca package
package "nsca-client"

## nsca config
file "#{@confdir}/send_nsca.cfg" do
  content <<EOF
####################################################
## Sample NSCA Client Config File 
#
# ENCRYPTION PASSWORD
#password=

# ENCRYPTION METHOD
#       1 = Simple XOR  (No security, just obfuscation, but very fast)
encryption_method=1
EOF
  mode "0644"
end

## rasca cron jobs
cron "rasca-Emergency" do
  minute "*/5"
  command '/bin/bash -l -c "/usr/sbin/rasca_scheduler Emergency"'
end
cron "rasca-Urgent" do
  minute "15"
  command '/bin/bash -l -c "/usr/sbin/rasca_scheduler Urgent"'
end
cron "rasca-Warning" do
  hour "2"
  minute "30"
  command '/bin/bash -l -c "/usr/sbin/rasca_scheduler Warning"'
end
