#
# Copyright (C) 2017 Red Hat Inc.
#
# Author: Luke Hinds  <lhinds@redhat.com>
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
#
# == Class: tripleo::profile::base::neutron::bgpvpn
#
# Aide profile for TripleO
#
# === Parameters
#
# [*step*]
#   (Optional) The current step in deployment. See tripleo-heat-templates
#   for more details.
#   Defaults to hiera('step')
#
class tripleo::profile::base::aide (
  $package             = hiera('package', undef),
  $hour                   = hiera('hour', undef),
  $minute               = hiera('minute', undef),
  $email                  = hiera('email', undef),
  $command          = '/usr/sbin/aide',
  $conf_path          = '/etc/aide.conf',
  $mail_path          = '/bin/mail',
  $rules                   = {},
  $check_parameters = "--config=${conf_path}",
  $step                    = hiera('step')
) {
  include ::tripleo::profile::base::aide

  if $step >=1 {
    package { 'aide':
      ensure => $::aide::version,
      name   => $package,
      alias  => 'aide',
    }

    include ::tripleo::profile::base::aide::installdb

    concat { 'aide.conf':
      path           => $conf_path,
      owner          => 'root',
      group          => 'root',
      mode           => '0600',
      ensure_newline => true,
      require        => Package['aide']
    }

    concat::fragment { 'aide.conf.header':
      target  => 'aide.conf',
      order   => 0,
      content => template( 'tripleo/aide/aide.conf.erb')
    }

# If a hash of rules is supplied with class then call auditd::rules
    if $rules {
      create_resources('::::tripleo::profile::base::aide::rules', $rules)
    }
    contain 'aide::cron'
  }
}
