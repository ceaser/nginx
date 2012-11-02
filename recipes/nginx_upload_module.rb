#
# Cookbook Name:: nginx
# Recipe:: nginx_upload_module
#
# Author:: Ceaser Larry (<clarry@divergentlogic.com>)
#
# Copyright 2012, Divergent Logic, LLC
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

upload_module_src_filename = ::File.basename(node['nginx']['upload']['url'])
upload_module_src_filepath = "#{Chef::Config['file_cache_path']}/#{upload_module_src_filename}"
upload_module_extract_path = "#{Chef::Config['file_cache_path']}/nginx_upload_module-#{node['nginx']['upload']['version']}"

remote_file upload_module_src_filepath do
  source node['nginx']['upload']['url']
  checksum node['nginx']['upload']['checksum']
  owner "root"
  group "root"
  mode 00644
end

execute "extract_upload_module" do
  command "tar zxf #{upload_module_src_filepath}"
  cwd Chef::Config['file_cache_path']
  not_if "test -d #{upload_module_extract_path}"
end

node.run_state['nginx_configure_flags'] =
  node.run_state['nginx_configure_flags'] | ["--add-module=#{upload_module_extract_path}"]
