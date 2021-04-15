# Define: dnf module
#
define dnf::module (
  String $ensure,
  String $state='enabled',
  String $dnf_name=$title,
  Variant[Integer,Float,String] $stream=undef,
  String $profiles='*'
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
        "set ${dnf_name}/name '${dnf_name}'",
        "set ${dnf_name}/state '${state}'",
        "set ${dnf_name}/stream '${stream}'",
        "set ${dnf_name}/profiles '${profiles}'",
      ],
      require => File["/etc/dnf/modules.d/${title}.module"]
    }
  }
}
