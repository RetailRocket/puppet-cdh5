$fqdn = 'hive1.domain.org'
class { '::cdh5::hadoop':
    namenode_hosts => ['localhost'],
    dfs_name_dir   => '/var/lib/hadoop/name',
}

class { 'cdh5::hive':
    metastore_host  => $fqdn,
    zookeeper_hosts => ['zk1.domain.org', 'zk2.domain.org'],
    jdbc_password   => 'test',
}
class { 'cdh5::hive::master': }
