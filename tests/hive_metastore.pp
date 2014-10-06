$fqdn = 'hive1.domain.org'
class { 'cdh5::hive':
    metastore_host  => $fqdn,
    zookeeper_hosts => ['zk1.domain.org', 'zk2.domain.org'],
    jdbc_password   => 'test',
}
class { 'cdh5::hive::metastore': }

