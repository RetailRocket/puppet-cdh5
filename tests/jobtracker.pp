
class { '::cdh5::hadoop':
    use_yarn       => false,
    namenode_hosts => ['localhost'],
    dfs_name_dir   => '/var/lib/hadoop/name',
}

# jobtracker requires namenode
include cdh5::hadoop::master
include cdh5::hadoop::jobtracker
