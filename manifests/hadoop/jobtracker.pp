# == Class cdh5::hadoop::jobtracker
# Installs and configures Hadoop MRv1 JobTracker.
# This will ensure that the MFv1 HDFS directories exist.
# This class may only be included on the NameNode Master
# Hadoop node.
#
class cdh5::hadoop::jobtracker {
    Class['cdh5::hadoop::namenode'] -> Class['cdh5::hadoop::jobtracker']

    if $::cdh5::hadoop::ha_jobtracker {
	$jobtracker_package = 'hadoop-0.20-mapreduce-jobtrackerha'
    }else{
	$jobtracker_package = 'hadoop-0.20-mapreduce-jobtracker'
    }

    if $::cdh5::hadoop::use_yarn {
        fail('Cannot use Hadoop MRv1 JobTrackker if cdh5::hadoop::use_yarn is true.')
    }

    package { 'hue-plugins':
        ensure  => 'installed',
    }

    exec { 'cp hue-plugins':
        command => 'cp -f -s /usr/lib/hadoop/lib/hue-plugins-*.jar /usr/lib/hadoop-0.20-mapreduce/lib',
        path    => "/usr/local/bin/:/bin/",
        require => [ Package[$jobtracker_package], Package['hue-plugins'] ],
    }

    # Create MRv1 directories.
    # See: http://www.cloudera.com/content/cloudera-content/cloudera-docs/CDH4/4.2.0/CDH4-Installation-Guide/cdh4ig_topic_11_3.html

    # Make sure HDFS directories are created before
    # jobtracker is installed and started, but after
    # the namenode.
    cdh5::Hadoop::Directory {
        before  => Package[$jobtracker_package],
        require => Service['hadoop-hdfs-namenode'],
    }

    # sudo -u hdfs hadoop fs -mkdir /tmp/mapred
    # sudo -u hdfs hadoop fs -chown mapred:hadoop /tmp/mapred
    # sudo -u hdfs hadoop fs -chmod 1777 /tmp/mapred
    cdh5::hadoop::directory { '/tmp/mapred':
        owner   => 'mapred',
        group   => 'hadoop',
        mode    => '1777',
        require => cdh5::Hadoop::Directory['/tmp'],
    }

    # sudo -u hdfs hadoop fs -mkdir /tmp/mapred/system
    # sudo -u hdfs hadoop fs -chown mapred:hadoop /tmp/mapred/system
    # sudo -u hdfs hadoop fs -chmod 1777 /tmp/mapred/system
    cdh5::hadoop::directory { '/tmp/mapred/system':
        owner   => 'mapred',
        group   => 'hadoop',
        mode    => '1777',
        require => cdh5::Hadoop::Directory['/tmp/mapred'],
    }

    # sudo -u hdfs hadoop fs -mkdir /var/lib/hadoop-hdfs
    cdh5::hadoop::directory { '/var/lib/hadoop-hdfs':
        owner   => 'hdfs',
        group   => 'hdfs',
        mode    => '0755',
        require => cdh5::Hadoop::Directory['/var/lib'],
    }

    # sudo -u hdfs hadoop fs -mkdir /var/lib/hadoop-hdfs/cache
    cdh5::hadoop::directory { '/var/lib/hadoop-hdfs/cache':
        owner   => 'hdfs',
        group   => 'hdfs',
        mode    => '0755',
        require => cdh5::Hadoop::Directory['/var/lib/hadoop-hdfs'],
    }

    # sudo -u hdfs hadoop fs -mkdir /var/lib/hadoop-hdfs/cache/mapred
    # sudo -u hdfs hadoop fs -chown mapred:hdfs /var/lib/hadoop-hdfs/cache/mapred
    cdh5::hadoop::directory { '/var/lib/hadoop-hdfs/cache/mapred':
        owner   => 'mapred',
        group   => 'hdfs',
        mode    => '0755',
        require => cdh5::Hadoop::Directory['/var/lib/hadoop-hdfs/cache'],
    }

    # sudo -u hdfs hadoop fs -mkdir /var/lib/hadoop-hdfs/cache/mapred/mapred
    # sudo -u hdfs hadoop fs -chown mapred:hdfs /var/lib/hadoop-hdfs/cache/mapred/mapred
    cdh5::hadoop::directory { '/var/lib/hadoop-hdfs/cache/mapred/mapred':
        owner   => 'mapred',
        group   => 'hdfs',
        mode    => '0755',
        require => cdh5::Hadoop::Directory['/var/lib/hadoop-hdfs/cache/mapred'],
    }

    # sudo -u hdfs hadoop fs -mkdir /var/lib/hadoop-hdfs/cache/mapred/mapred/staging
    # sudo -u hdfs hadoop fs -chown mapred:hdfs /var/lib/hadoop-hdfs/cache/mapred/mapred/staging
    # sudo -u hdfs hadoop fs -chmod 1777 /var/lib/hadoop-hdfs/cache/mapred/mapred/staging
    cdh5::hadoop::directory { '/var/lib/hadoop-hdfs/cache/mapred/mapred/staging':
        owner   => 'mapred',
        group   => 'hdfs',
        mode    => '1777',
        require => cdh5::Hadoop::Directory['/var/lib/hadoop-hdfs/cache/mapred/mapred'],
    }

    # install jobtracker daemon package
    package { $jobtracker_package:
        ensure  => 'installed',
    }

    service { $jobtracker_package :
        ensure     => 'running',
        enable     => true,
        hasstatus  => true,
        hasrestart => true,
        alias      => 'jobtracker',
        require    => Package[$jobtracker_package],
    }
}
