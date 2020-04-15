# Define: dnf module
#
define dnf::module (
  $ensure,
  $state=enabled,
  $stream=undef,
  $profiles='*'
) {

  file { "/etc/dnf/modules.d/${title}.module":
    ensure => $ensure
  }

  if $ensure == present {
    augeas { "/etc/dnf/modules.d/${title}.module":
      lens    => 'PHP.lns',
      incl    => "/etc/dnf/modules.d/${title}.module",
      context => "/files/etc/dnf/modules.d/${title}.module",
      changes => [
        "set ${name}/name '${name}'",
        "set ${name}/state '${state}'",
        "set ${name}/stream '${stream}'",
        "set ${name}/profiles '${profiles}'",
      ],
      require => File["/etc/dnf/modules.d/${title}.module"]
    }
  }
}
