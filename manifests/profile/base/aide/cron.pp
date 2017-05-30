# Conifigures cron and installs mailx is `email` parameter is defined
class tripleo::profile::base::aide::aide::cron ( inherits aide {
    if $::tripleo::profile::base::aide::aide::email {
      $cron_entry = "${tripleo::profile::base::aide::command} --check ${tripleo::profile::base::aide::check_parameters} | ${tripleo::profile::base::aide::mail_path} -s \"\$HOSTNAME - Daily AIDE integrity check\" ${tripleo::profile::base::aide::email}"
        package { 'mailx':
          ensure => installed,
        }
      }
      else {
        $cron_entry = "${tripleo::profile::base::aide::command} --check ${tripleo::profile::base::aide::check_parameters} > /var/log/audit/aide_`date +%Y-%m-%d`.log"
      }
      cron { 'aide':
        command => $cron_entry,
        user    => 'root',
        hour    => $::tripleo::profile::base::aide::hour,
        minute  => $::tripleo::profile::base::aide::minute,
        require => [Package['aide'], Exec['install aide db']]
      }
    }
