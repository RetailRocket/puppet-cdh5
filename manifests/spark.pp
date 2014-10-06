# == Class cdh5::spark
class cdh5::spark inherits cdh5::spark::defaults {

	package { 'spark' :
        	ensure => 'installed',
    	}

	package { 'spark-core' :
		ensure => 'installed',
	}

}
