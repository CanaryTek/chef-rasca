#
# Author:: Miguel Armas <kuko@canarytek.com>
# Cookbook Name:: rasca
# Recipe:: nsca_ng_client
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

# Icinga repo
yum_key "RPM-GPG-KEY-Icinga" do
  url "http://packages.icinga.org/icinga.key"
  action :add
end
yum_repository "icinga" do
  description "Icinga (Nagios) repo for RHEL/CentOS"
  url "http://packages.icinga.org/epel/$releasever/release/"
  key "RPM-GPG-KEY-Icinga"
  enabled "1"
  priority "5"
  action :add
end

# install nsca-ng service from package
package "nsca-ng-client" do
  action :install
end

template "/etc/modularit/send_nsca.cfg" do
  source "send_nsca_ng.cfg.erb"
  mode 0600
end

