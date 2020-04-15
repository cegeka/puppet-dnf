# Define: dnf::plugin
#
# This definition installs DNF plugin.
#
# Parameters:
#   [*ensure*]   - specifies if plugin should be present or absent
#
# Actions:
#
# Requires:
#   RPM based system
#
# Sample usage:
#   dnf::plugin { 'versionlock':
#     ensure  => 'present',
#   }
#
define dnf::plugin (
  Enum['present', 'absent'] $ensure     = 'present',
  Optional[String]          $pkg_prefix = undef,
  Optional[String]          $pkg_name   = undef,
) {
  if $pkg_prefix {
    $_pkg_prefix = $pkg_prefix
  } else {
    $_pkg_prefix = $facts['os']['release']['major'] ? {
      default => 'python3-dnf-plugin',
    }
  }

  $_pkg_name = $pkg_name ? {
    Variant[Enum[''], Undef] => "${_pkg_prefix}-${name}",
    default                  => "${_pkg_prefix}-${pkg_name}",
  }

  package { $_pkg_name:
    ensure  => $ensure,
  }

}
