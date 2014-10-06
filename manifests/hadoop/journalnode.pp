# == Class cdh5::hadoop::journalnode
#
class cdh5::hadoop::journalnode {
    Class['cdh5::hadoop'] -> Class['cdh5::hadoop::journalnode']

    # install jobtracker daemon package
    package { 'hadoop-hdfs-journalnode':
        ensure => 'installed'
    }

    # Ensure that the journanode edits directory has the correct permissions.
    file { $::cdh5::hadoop::dfs_journalnode_edits_dir:
        ensure  => 'directory',
        owner   => 'hdfs',
        group   => 'hdfs',
        mode    => '0755',
        require => Package['hadoop-hdfs-journalnode'],
    }

    # install datanode daemon package
    service { 'hadoop-hdfs-journalnode':
        ensure     => 'running',
        enable     => true,
        hasstatus  => true,
        hasrestart => true,
        alias      => 'journalnode',
        require    => File[$::cdh5::hadoop::dfs_journalnode_edits_dir],
    }
}
