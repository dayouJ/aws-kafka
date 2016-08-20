# Dealing with Zookeeper
#

# Get zookeeper servers either from ENV or from chef environment provided by knife
# Must be in a form of comma-separated list
node.override['zookeeper']['servers'] = ENV['zk_servers'].to_s.empty? ? node['zookeeper']['servers'] : ENV['zk_servers']

# IPFinder depends on this gem
chef_gem "ipaddr_extensions" do
  version '1.0.0'
end

quorum_config = {}
zk_servers=node['zookeeper']['servers']
if not zk_servers.nil?
   zk_servers = zk_servers.split(',')
   zk_servers.each_with_index do |server, index|
       quorum_config["server.#{index}"] = "#{server}:#{node['zookeeper']['peer_port']}:#{node['zookeeper']['leader_port']}"
   end
end
node.override['zookeeper']['config'] = node['zookeeper']['config'].merge(quorum_config)

# Configuring myid
template "#{node['zookeeper']['config']['dataDir']}/myid" do
  source "myid.erb"
  owner node['zookeeper']['user']
  variables({
    :zk_servers => node['zookeeper']['servers']
  })
  not_if { node['zookeeper']['servers'].nil? }
end
