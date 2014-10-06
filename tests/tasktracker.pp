#

class { '::cdh5::hadoop':
    use_yarn       => false,
    namenode_hosts => ['localhost'],
    dfs_name_dir   => '/var/lib/hadoop/name',
}

include cdh5::hadoop::tasktracker
