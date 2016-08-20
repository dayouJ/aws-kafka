WORKING_DIR="/deploy"
REPO_DIR="$WORKING_DIR/repo"
RUBY_URL="https://rvm_io.global.ssl.fastly.net/binaries/ubuntu/14.04/x86_64/ruby-2.1.5.tar.bz2"
command curl -sSL https://rvm.io/mpapis.asc | gpg --import -
curl -sSL https://get.rvm.io | bash -s stable
source /usr/local/rvm/scripts/rvm
echo "$RUBY_URL=1a201d082586036092cfc5b79dd26718" >> /usr/local/rvm/user/md5
echo "$RUBY_URL=91216074cb5f66ef5e33d47e5d3410148cc672dc73cc0d9edff92e00d20c9973bec7ab21a3462ff4e9ff9b23eff952e83b51b96a3b11cb5c23be587046eb0c57" >> /usr/local/rvm/user/sha512
rvm mount -r $RUBY_URL --verify-downloads 1
rvm use 2.1.5 --default
rvm rubygems current
wget https://stedolan.github.io/jq/download/linux64/jq -O /usr/local/bin/jq
chmod +x /usr/local/bin/jq
curl -L https://www.opscode.com/chef/install.sh | bash
gem install bundler --no-ri --no-rdoc
cd $REPO_DIR/chef/ && bundle install && librarian-chef install
chef-solo -c "$REPO_DIR/chef/solo.rb" -j "$REPO_DIR/chef/solo_kb.json"
