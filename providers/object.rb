#
# Cookbook Name:: rasca
# Provider:: object
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

# Returns the extension of the file depending on the format of content
def extension
  case new_resource.format
    when "yaml"
      "obj"
    when "ruby"
      "rb"
    end
end

# Adds an object file to a check
# If content attribute is given, it's used, else it will try to use a template with that name
action :add do
  dir_name="#{node['rasca']['objdir']}/#{new_resource.check}"
  file_name="#{new_resource.object_name}.#{extension}"
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
  # If content is given, use it
  Chef::Log.info "Creating object file #{dir_name}/#{file_name}"
  if new_resource.respond_to?("content")
    file "#{dir_name}/#{file_name}" do
      content new_resource.content
    end
  else
    # No content given, try to use a template
    template "#{dir_name}/#{file_name}" do
      source "#{file_name}.erb"
      mode 00644
      action :create
    end
  end
end

action :remove do
  file_name="#{node['rasca']['objdir']}/#{new_resource.check}/#{new_resource.object_name}.#{extension}"
  if ::File.exists?(file_name)
    Chef::Log.info "Removing #{file_name}"
    file file_name do
      action :delete
    end
    new_resource.updated_by_last_action(true)
  end
end

