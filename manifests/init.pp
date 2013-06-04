
class riak{
	#
        #String builder for join cluster
        $cmd1 = "sh riak-admin cluster join riak@$riakhost"
        $cmd2 = ";riak-admin cluster plan;"
        $cmd3 = "riak-admin cluster commit"
        $cmd  =  "$cmd1$cmd2$cmd3"
        #
	package{"libssl0.9.8":
		ensure => installed;
		"curl":
		ensure => installed;
	}~>
#	file {
#	  "~/riak_1.3.1-1_amd64.deb":
#		ensure => "present",
#		source => "puppet:///modules/riak/riak_1.3.1-1_amd64.deb";
#	  "~/riak-cs_1.3.1-1_amd64.deb":
#		ensure =>"present",
#		source => "puppet:///modules/riak/riak-cs_1.3.1-1_amd64.deb";
#	   "~/stanchion_1.3.1.1-1_amd64.deb":
#		ensure => "present",
#		source => "puppet:///modules/riak/stanchion_1.3.1.1-1_amd64.deb";
#	} ~>
	exec {
	 "Get riak":
	   command => "sudo wget http://s3.amazonaws.com/downloads.basho.com/riak/1.3/1.3.1/ubuntu/precise/riak_1.3.1-1_amd64.deb",
 	   cwd     => "~/",
	   creates => "/etc/riak";
	 "Get stanchion":
	   command => "sudo wget http://s3.amazonaws.com/downloads.basho.com/stanchion/1.3/1.3.1.1/ubuntu/precise/stanchion_1.3.1.1-1_amd64.deb",
	   cwd     => "~/",
	   creates => "/etc/stanchion";
	 "Get riak cs":
	   command => "sudo wget http://s3.amazonaws.com/downloads.basho.com/riak-cs/1.3/1.3.1/ubuntu/precise/riak-cs_1.3.1-1_amd64.deb",
	   cwd     => "~/",
	   creates => "/etc/riak-cs";
	}~>
	exec {
	 "install riak":
	   command => "sudo dpkg -i ~/riak_1.3.1-1_amd64.deb", 		
	   creates => "/etc/riak";
	 "install riak-cs":
	   command => "sudo dpkg -i ~/riak-cs_1.3.1-1_amd64.deb",
	   creates => "/etc/riak-cs";
	 "install stanchion": 
	   command => "sudo dpkg -i ~/stanchion_1.3.1.1-1_amd64.deb",
	   creates => "/etc/stanchion"; 	
	}~> 
	file {
	 "/etc/riak/app.config":
           ensure  => file,
	   content => template("${module_name}/app.erb");
         "/etc/riak/vm.args":
           ensure  => file,
           content => template("${module_name}/vm.erb");
	 "/etc/riak-cs/app.config":
          ensure  => file,
	   content => template("${module_name}/app_cs.erb");
         "/etc/riak-cs/vm.args":
          ensure  => file,
          content => template("${module_name}/vm_cs.erb");
	 "/etc/stanchion/app.config":
           ensure  => file,
	   owner   => "stanchion",
	   group   => "riak",
  	   content => template("${module_name}/app_st.erb");	   
         "/etc/stanchion/vm.args":
           ensure  => file,
	   owner   => "stanchion",
	   group   => "riak",
	   content => template("${module_name}/vm_st.erb");
         "/etc/security/limits.conf":
           ensure  => file,
           source  => "puppet:///modules/riak/limits.conf",
	   replace => true; 
       }~>
	exec{
	 "riak start":
	   command => "riak start",
	   unless => "riak ping",
	   cwd => "/usr/sbin";
	"stanchion start":
	   command => "stanchion start",
	   unless => "stanchion ping",
	   cwd => "/usr/sbin";
	"riak-cs start":
	   command => "riak-cs start",
	   unless => "riak-cs ping",
	   cwd => "/usr/sbin";
	} ~>
	exec{ "riak join":
           command => $cmd,
           cwd     => "/usr/sbin",
           onlyif  => $cmd1;
 	}
}
