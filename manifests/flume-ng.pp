class cdh5::flume-ng (
  $flume_home           = "/etc/flume-ng",
  $flume_logs_dir       = "/var/log/flume-ng/",
  $flume_agent          = "agent",
  $flume_jmxremote_port = undef,
  $flume_user           = "root",
  $flume_heap_size      = "4G"
) {

    
  package { [ 'flume-ng', 'flume-ng-agent' ]:
    ensure => 'installed',
  }

  file { "/etc/init.d/flume-ng-agent":
    content => template("cdh5/flume-ng/flume-ng-agent.erb"),
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    notify  => Service['flume-ng-agent'],
    require => Package["flume-ng-agent"];
  }

  file { "${flume_home}/conf/log4j.properties":
    content => template("cdh5/flume-ng/log4j.properties.erb"),
    require => Package["flume-ng-agent"];
  }

  file { "${flume_home}/conf/flume-env.sh":
    content => template("cdh5/flume-ng/flume-env.sh.erb"),
    owner   => root,
    require => Package["flume-ng-agent"];
  }

  file { "/var/run/flume-ng" :
    recurse => true,
    owner   => $flume_user,
    group   => $flume_user,
    require => Package["flume-ng-agent"];
  }

  file { "${flume_home}/conf/flume-agent.conf":
    source  => "puppet:///modules/cdh5/flume-ng/flume-agent.conf",
    owner   => root,
    require => Package["flume-ng-agent"];
  }

  file { "${flume_logs_dir}" :
    recurse => true,
    owner   => $flume_user,
    group   => $flume_user,
    require => Package["flume-ng-agent"];
  }
  
  service { 'flume-ng-agent':
    ensure     => 'running',
    hasrestart => true,
    hasstatus  => true,
  }

}
