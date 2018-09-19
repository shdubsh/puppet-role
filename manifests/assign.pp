# Assigns the role.
define role::assign (
  $prefix     = undef,
  $datacenter = undef,
  $tld        = undef,
  $role       = undef
) {
  include motd
  motd::script { "role-${role}":
    ensure   => present,
    priority => 5,
    content  => "#!/bin/sh\necho '${hiera("role::${role}::description")}'\n",
  }

  if (defined("role::${role}")) {
    include("role::${role}")
  }
  else {
    notify { 'Error':
      message => "No such role defined: role::${role}"
    }
  }
}
