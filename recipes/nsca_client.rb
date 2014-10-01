# Cookbook Name:: rasca
# Recipe:: nsca_client
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

## nsca package
package "nsca-client"

## nsca config
file "/etc/modularit/send_nsca.cfg" do
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

