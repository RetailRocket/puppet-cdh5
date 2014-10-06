# == Class cdh5::hadoop::resourcemanager
# Installs and configures Hadoop YARN ResourceManager.
# This will create YARN HDFS directories.
#
class cdh5::hadoop::resourcemanager {
    Class['cdh5::hadoop::namenode'] -> Class['cdh5::hadoop::resourcemanager']

    if !$::cdh5::hadoop::use_yarn  {
        fail('Cannot use Hadoop YARN ResourceManager if cdh5::hadoop::use_yarn is false.')
    }

    # Create YARN HDFS directories.
    # See: http://www.cloudera.com/content/cloudera-content/cloudera-docs/CDH4/4.2.0/CDH4-Installation-Guide/cdh4ig_topic_11_4.html
    cdh5::hadoop::directory { '/var/log/hadoop-yarn':
        # sudo -u hdfs hadoop fs -mkdir /var/log/hadoop-yarn
        # sudo -u hdfs hadoop fs -chown yarn:mapred /var/log/hadoop-yarn
        owner   => 'yarn',
        group   => 'mapred',
        mode    => '0755',
        # Make sure HDFS directories are created before
        # resourcemanager is installed and started, but after
        # the namenode.
        require => [Service['hadoop-hdfs-namenode'], Cdh5::Hadoop::Directory['/var/log']],
    }

    package { 'hadoop-yarn-resourcemanager':
        ensure  => 'installed',
        require => Cdh5::Hadoop::Directory['/var/log/hadoop-yarn'],
    }

    service { 'hadoop-yarn-resourcemanager':
        ensure     => 'running',
        enable     => true,
        hasstatus  => true,
        hasrestart => true,
        alias      => 'resourcemanager',
        require    => Package['hadoop-yarn-resourcemanager'],
    }
}
