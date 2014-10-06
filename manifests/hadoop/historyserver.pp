# == Class cdh5::hadoop::historyserver
# Installs and starts up a Hadoop YARN HistoryServer.
# This will ensure that the HDFS /user/history exists.
# This class may only be included on the NameNode Master
# Hadoop node.
#
class cdh5::hadoop::historyserver {
    Class['cdh5::hadoop::namenode'] -> Class['cdh5::hadoop::historyserver']

    if !$::cdh5::hadoop::use_yarn {
        fail('Cannot use Hadoop YARN NodeManager if cdh5::hadoop::use_yarn is false.')
    }

    # Create HistoryServer HDfS directories.
    # See: http://www.cloudera.com/content/cloudera-content/cloudera-docs/CDH4/4.2.0/CDH4-Installation-Guide/cdh4ig_topic_11_4.html
    cdh5::hadoop::directory { '/user/history':
        # sudo -u hdfs hadoop fs -mkdir /user/history
        # sudo -u hdfs hadoop fs -chmod -R 1777 /user/history
        # sudo -u hdfs hadoop fs -chown yarn /user/history
        owner   => 'yarn',
        group   => 'hdfs',
        mode    => '1777',
        # Make sure HDFS directories are created before
        # historyserver is installed and started, but after
        # the namenode.
        require => [Service['hadoop-hdfs-namenode'], Cdh5::Hadoop::Directory['/user']],
    }

    package { 'hadoop-mapreduce-historyserver':
        ensure  => 'installed',
        require => Cdh5::Hadoop::Directory['/user/history'],
    }

    service { 'hadoop-mapreduce-historyserver':
        ensure     => 'running',
        enable     => true,
        hasstatus  => true,
        hasrestart => true,
        alias      => 'historyserver',
        require    => Package['hadoop-mapreduce-historyserver'],
    }
}
