# Define: dnf module
#
# A DNF module can be defined as followed:
# 'module-stream':
#   dnf_name: 'module'    # The official name of the DNF module (dnf module list)
#   stream: 'stream'      # The stream of the DNF module (dnf module list)
#
define dnf::module (
  String $ensure,
  String $state='enabled',
  String $dnf_name=$title,
  Variant[Integer,Float,String] $stream=undef,
  String $profiles='*'
) {

  file { "/etc/dnf/modules.d/${dnf_name}.module":
    ensure  => $ensure
  }

  file_line { "Dnf::Module ${dnf_name} owned by puppet":
    path => "/etc/dnf/modules.d/${dnf_name}.module",
    line => '# This file is managed by puppet'
  }

  if $ensure == present {
    augeas { "Dnf::Module ${title}":
      lens    => 'PHP.lns',
      incl    => "/etc/dnf/modules.d/${dnf_name}.module",
      context => "/files/etc/dnf/modules.d/${dnf_name}.module",
      changes => [
        "set ${dnf_name}/name '${dnf_name}'",
        "set ${dnf_name}/state '${state}'",
        "set ${dnf_name}/stream '${stream}'",
        "set ${dnf_name}/profiles '${profiles}'",
      ],
      require => [
        File["/etc/dnf/modules.d/${dnf_name}.module"],
        File_line["Dnf::Module ${dnf_name} owned by puppet"]
      ]
    }
  }
}
