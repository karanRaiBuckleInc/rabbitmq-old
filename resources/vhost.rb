# frozen_string_literal: true
#
# Cookbook Name:: rabbitmq
# Resource:: vhost
#
# Copyright 2011-201, Chef Software, Inc.
# Copyright 2019-2021, VMware, Inc or its affiliates.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

unified_mode true if respond_to?(:unified_mode)

property :vhost, String, name_property: true

action_class do
  include RabbitMQ::CoreHelpers

  def vhost_exists?(name)
    cmd = "rabbitmqctl -q list_vhosts | grep ^#{name}$"
    cmd = Mixlib::ShellOut.new(cmd, :env => shell_environment)
    cmd.run_command
    Chef::Log.debug "rabbitmq_vhost_exists?: #{cmd}"
    Chef::Log.debug "rabbitmq_vhost_exists?: #{cmd.stdout}"
    !cmd.error?
  end
end

action :add do
  cmd = "rabbitmqctl -q add_vhost #{new_resource.vhost}"
  execute cmd do
    Chef::Log.debug "rabbitmq_vhost_add: #{cmd}"
    Chef::Log.info "Adding RabbitMQ vhost '#{new_resource.vhost}'."
    environment shell_environment
    not_if { vhost_exists?(new_resource.vhost) }
  end
end

action :delete do
  cmd = "rabbitmqctl -q delete_vhost #{new_resource.vhost}"
  execute cmd do
    Chef::Log.debug "rabbitmq_vhost_delete: #{cmd}"
    Chef::Log.info "Deleting RabbitMQ vhost '#{new_resource.vhost}'."
    environment shell_environment
    only_if { vhost_exists?(new_resource.vhost) }
  end
end
