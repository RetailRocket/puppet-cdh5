#

class { '::cdh5::hadoop':
    namenode_hosts    => ['localhost', 'nonya'],
    dfs_name_dir      => '/var/lib/hadoop/name',
    nameservice_id    => 'test-cdh4',
    journalnode_hosts => ['localhost', 'nonya'],
}

include cdh5::hadoop::namenode::standby
