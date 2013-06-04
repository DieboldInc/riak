RiakCS Cluster deployment via Puppet
====================================

What it does:

This repository is a puppet module for quickly deploying a RiakCS cluster across any number of nodes.  This module also handles joining new nodes to the current group through a 'riakhost' parameter which serves as a common node.    


How to use:

1. Clone this repository into your puppet module directory
2. Define a class named 'riak' in your puppet console 
3. Assign a group in puppet CS that uses the 'riak' class
4. Set a parameter for that group named 'riakhost'
   a. This should be set to the ip address of the node in the group that you want to designate as the riak host
   b. ie:  Key: riakhost Value: 127.0.0.1
5. Designate nodes to the puppet group that you wish to be part of the RiakCS cluster, ensuring that the host is 
   configured by puppet first 
6. After puppet configures all the nodes run 'riak-admin status | grep ring_members' from a node console to check the 
   cluster status
