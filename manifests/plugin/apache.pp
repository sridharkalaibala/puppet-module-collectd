# https://collectd.org/wiki/index.php/Plugin:Apache
class collectd::plugin::apache (
  $ensure     = present,
  $instances  = { 'localhost' => { 'url' => 'http://localhost/mod_status?auto' } },
  $package    = undef,
) {
  include collectd::params

  $conf_dir = $collectd::params::plugin_conf_dir
  validate_hash($instances)

  if ($package != undef){
    package {$package:
      ensure => $collectd::plugin::apache::ensure,
      notify => Service['collectd'],
    }
  }

  file { 'apache.conf':
    ensure    => $collectd::plugin::apache::ensure,
    path      => "${conf_dir}/apache.conf",
    mode      => '0644',
    owner     => 'root',
    group     => $collectd::params::root_group,
    content   => template('collectd/apache.conf.erb'),
    notify    => Service['collectd'],
  }
}
