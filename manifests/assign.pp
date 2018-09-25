# Assigns the role.
define role::assign (
  $prefix     = undef,
  $datacenter = undef,
  $tld        = undef,
  $role       = undef
) {
  include base
  include motd
  motd::script { "role-${role}":
    ensure   => present,
    priority => 5,
    content  => "#!/bin/sh\necho '${hiera("role::${role}::description")}'\n",
  }

  $includes = hiera("role::${role}::includes", [])

  $includes.each |String $inc| {
    if (defined($inc)) {
      include($inc)
    }
    else {
      notify { 'Error': message => "No such definition: ${inc}" }
    }
  }
}
