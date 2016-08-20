require 'chef/version_constraint'

file_cache_path    "/var/chef/cache"
file_backup_path   "/var/chef/backup"

cookbook_path   [ "/deploy/zookeeper/chef/cookbooks", "/deploy/zookeeper/chef/site-cookbooks" ]
data_bag_path   "/deploy/zookeeper/chef/data_bags"
role_path       "/deploy/zookeeper/chef/roles"

log_level :info
verbose_logging    false

encrypted_data_bag_secret nil

http_proxy nil
http_proxy_user nil
http_proxy_pass nil
https_proxy nil
https_proxy_user nil
https_proxy_pass nil
no_proxy nil

Chef::Config.ssl_verify_mode = :verify_none
