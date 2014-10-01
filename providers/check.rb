#
# Cookbook Name:: rasca
# Provider:: check
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
#

def whyrun_supported?
  true
end

action :add do
  dir_name="#{node['rasca']['alarmdir']}/#{new_resource.priority}"
  link_name="#{new_resource.check_name}-picacaller"
  # Create dir if needed
  unless ::File.directory?(dir_name)
    Chef::Log.info "Creating directory #{dir_name}"
    directory dir_name do
      owner "root"
      group "root"
      mode 00755
      recursive true
      action :create
    end
  end
  # Create link
  unless ::File.exists?("#{dir_name}/#{link_name}")
    Chef::Log.info "Linking #{dir_name}/#{link_name} to /usr/bin/rascaCheck"
    link "#{dir_name}/#{link_name}" do
      if ::File.exists?("/usr/local/bin/rascaCheck")
        to "/usr/local/bin/rascaCheck"
      else
        to "/usr/bin/rascaCheck"
      end
    end
  end
end

action :remove do
  link_name="#{node['rasca']['alarmdir']}/#{new_resource.priority}/#{new_resource.check_name}-picacaller"
  if ::File.exists?(link_name)
    Chef::Log.info "Removing #{link_name}"
    link link_name do
      action :delete
    end
    new_resource.updated_by_last_action(true)
  end
end

