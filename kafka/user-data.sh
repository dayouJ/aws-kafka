REPO_DIR="$WORKING_DIR/kafka"

# Install RVM and RUBY
command curl -sSL https://rvm.io/mpapis.asc | gpg --import -
curl -sSL https://get.rvm.io | bash -s stable
source /usr/local/rvm/scripts/rvm
rvm install ruby-2.1.8
rvm use 2.1.8 --default
rvm rubygems current

# Install Chef and Cookbook dependencies
curl -L https://www.opscode.com/chef/install.sh | bash
gem install bundler --no-ri --no-rdoc
cd $REPO_DIR/chef/ && bundle install && librarian-chef install

# Install jq
wget https://stedolan.github.io/jq/download/linux64/jq -O /usr/local/bin/jq
chmod +x /usr/local/bin/jq

# Find zookeeper nodes that belong to the same deployment and environment
export NODES_FILTER="Name=tag:Name,Values=zookeeper.$DEPLOYMENT.$ENVIRONMENT"
export QUERY="Reservations[].Instances[].NetworkInterfaces[].PrivateIpAddress"
export zk_servers=$(sudo aws ec2 describe-instances --region "$REGION" --filters "$NODES_FILTER" --query "$QUERY" | /usr/local/bin/jq --raw-output 'join(",")')

# Find kafka nodes that belong to the same deployment and environment
export NODES_FILTER="Name=tag:Name,Values=kafka.$DEPLOYMENT.$ENVIRONMENT"
export QUERY="Reservations[].Instances[].NetworkInterfaces[].PrivateIpAddress"
export kafka_brokers=$(sudo aws ec2 describe-instances --region "$REGION" --filters "$NODES_FILTER" --query "$QUERY" | /usr/local/bin/jq --raw-output 'join(",")')
export kafka_version=$VERSION

# Run Chef
curl -s https://packagecloud.io/install/repositories/imeyer/runit/script.rpm.sh | sudo bash

chef-solo -c "$REPO_DIR/chef/solo.rb" -j "$REPO_DIR/chef/solo_kb.json"
