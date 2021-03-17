# Class: dnf::plugin::versionlock
#
# This class installs versionlock plugin
#
# Parameters:
#   [*ensure*] - specifies if versionlock should be present or absent
#   [*clean*] - specifies if yum clean all should be called after edits. Defaults false.
#
# Actions:
#
# Requires:
#
# Sample usage:
#   include dnf::plugin::versionlock
#
class dnf::plugin::versionlock (
  Enum['present', 'absent'] $ensure = 'present',
  String                    $path   = '/etc/dnf/plugins/versionlock.list',
  Boolean                   $clean  = false,
) {

  dnf::plugin { 'versionlock':
    ensure  => $ensure,
  }

  concat { "dnf-plugin-versionlock-$path":
    mode   => '0644',
    owner  => 'root',
    group  => 'root'
  }

  concat::fragment { 'dnf_versionlock_header':
    target  => $path,
    content => "# File managed by puppet\n",
    order   => '01',
  }
}
