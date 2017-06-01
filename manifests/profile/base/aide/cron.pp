# Conifigures cron and installs mailx is `email` parameter is defined
class tripleo::profile::base::aide::cron (
  $step = hiera('step'),
  $command                = '/usr/sbin/aide',
  $conf_path                = '/etc/aide.conf',
  $check_parameters = "--config=${conf_path}",
  $hour                   = hiera('hour', undef),
  $minute               = hiera('minute', undef),
  $email                  = hiera('email', undef),
  $mail_path          = '/bin/mail',
  ) {
    if $email {
      $cron_entry = "${command} --check ${check_parameters} | $mail_path} -s \"\$HOSTNAME - Daily AIDE integrity check\" ${email}"
        package { 'mailx':
          ensure => installed,
        }
      }
      else {
        $cron_entry = "${command} --check ${check_parameters} > /var/log/audit/aide_`date +%Y-%m-%d`.log"
      }
      cron { 'aide':
        command => $cron_entry,
        user    => 'root',
        hour    => $hour,
        minute  => $minute,
        require => [Package['aide'], Exec['install aide db']]
      }
}
