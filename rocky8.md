# Rocky Linux 8 environtment

## IP Addresses

Host: 192.168.10.70

mailer:
```
exec env MAILER_HOST=dctmail.discovery.com \
MAILER_PORT=25 \
MAILER_NET_ENDP='tcp://*:6101' \
/home/siuyin/go/src/mailer/mailer-20190404_1752
```
## Development Tools

dnf group install "Development Tools"

dnf install tmux vim-enhanced wget sudo procps

## Go
wget https://go.dev/dl/go1.20.5.linux-amd64.tar.gz
 rm -rf /usr/local/go && tar -C /usr/local -xzf go1.20.5.linux-amd64.tar.gz

.bash_profile:
export PATH=$PATH:/usr/local/go/bin

## Ruby (via rvm)

```
gpg2 --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB

curl -sSL https://get.rvm.io | bash -s stable

rvm pkg install openssl
sudo dnf config-manager --set-enabled powertools  # named crb in rocky linux 9
sudo dnf install libyaml-devel
rvm install 1.8.7-p357 --with-openssl-dir=$HOME/.rvm/usr
rvm alias create default 1.8.7-p357

rvm rubygems 1.5.3 --force
gem install rails -v 2.3.3 --no-ri --no-rdoc
gem install rake -v 0.8.7 --no-ri --no-rdoc
rvm ruby-1.8.7-p357@global do gem uninstall rake -v 10.1.1

mkdir ~/app
git clone git@bitbucket.org:beyondbroadcast/vodossext.git
rake _0.8.7_ -T



```

## gem list
```
actionmailer (2.3.3)
actionpack (2.3.3)
activerecord (2.3.3)
activeresource (2.3.3)
activesupport (2.3.3)
builder (3.0.0)
cgi_multipart_eof_fix (2.5.0)
commonwatir (1.9.2)
daemon_controller (1.2.0)
daemons (1.1.4)
fastercsv (1.5.4)
fastthread (1.0.7)
ffi (1.0.11)
ffi-rzmq (0.9.3)
firewatir (1.9.2)
gem_plugin (0.2.3)
god (0.12.1)
hoe (2.10.0)
jeditable-rails (0.1.1)
json (1.8.2)
mechanize (2.0.1)
memcache-client (1.8.5)
mocha (0.9.12)
mongrel (1.1.5)
mysql (2.8.1)
net-http-digest_auth (1.1.1)
net-http-persistent (1.8)
nokogiri (1.5.0)
passenger (4.0.40)
pg (0.13.1)
rack (1.0.1)
rails (2.3.3)
rake (0.8.7)
rb-inotify (0.9.5)
rubygems-update (1.3.5)
s4t-utils (1.0.4)
sqlite3-ruby (1.2.4)
user-choices (1.1.6.1)
webrobots (0.0.10)
xml-simple (1.1.0)
zmq (2.1.4)
```

## zeromq

``
dnf install libuuid-devel
wget https://github.com/zeromq/zeromq2-x/releases/download/v2.2.0/zeromq-2.2.0.tar.gz
tar xf zeromq-2.2.0.tar.gz
cd zeromq-2.2.0
./configure
make -j8
make check
sudo make install
```
zeromq v2 libraries are install in /usr/local/lib as is libzmq.pc (pkgconfig)

## mailer

```
cd ~/app
git clone git@bitbucket.org:beyondbroadcast/mailer.git
cd mailer

PKG_CONFIG_PATH=/usr/local/lib/pkgconfig go build -v -o mailer main.go
#sudo echo "/usr/local/lib" >  /etc/ld.so.conf.d/usrlocal.conf
echo "/usr/local/lib" |sudo tee  /etc/ld.so.conf.d/usrlocal.conf
sudo ldconfig
```

## postgres 8.1.23

```
cd ~/tmp
wget https://ftp.postgresql.org/pub/source/v8.1.23/postgresql-8.1.23.tar.gz
tar xf postgresql-8.1.23.tar.gz
cd postgresql-8.1.23

export CFLAGS=-fno-aggressive-loop-optimizations
sudo dnf install readline-devel zlib-devel

./configure
make -j8
make check
sudo make install

follow INSTALL steps

gem install pg -v 0.13.1 --no-ri --no-rdoc -- --with-pg-config=/usr/local/pgsql/bin/pg_config
echo "/usr/local/pgsql/lib" | sudo tee /etc/ld.so.conf.d/postgres.conf
sudo ldconfig

```

## jobsmon
```
sudo -iu postgres
/usr/local/pgsql/bin/psql postgres
create database jobsmon_development;
create database jobsmon_production;
create database jobsmon_test;

create role siuyin with login;
# alter role siuyin with login;

grant all privileges on database jobsmon_development to siuyin;
grant all privileges on database jobsmon_production to siuyin;
grant all privileges on database jobsmon_test to siuyin;


#gem install --no-ri --no-rdoc passenger -v 4.0.40
gem install --no-ri --no-rdoc passenger -v 6.0.18
sudo dnf install pcre-devel curl-devel
passenger start -e development -p 3000 -d
# fix the ruby version checks by commenting out the higher ruby version path
passenger status
passenger stop
```

## runit (sv and friends)
```
wget http://smarden.org/runit/runit-2.1.2.tar.gz

# unpacks into admin sub-folder
tar xf runit-2.1.2.tar.gz

# manpages reference runit and not runit-2.1.2
ln -s runit-2.1.2 runit

cd admin/runit-2.1.2
cp src/Makefile src/Makefile.old

# compile dynamically linked executables rather than static
binaries will be in command/
sed -e 's/ -static//' <src/Makefile.old >src/Makefile
package/compile

package/check

# install by copying over execuatables
sudo mkdir -p /usr/local/runit/bin
sudo cp command/* /usr/local/runit/bin

# install man pages
sudo package/install-man

echo 'export PATH=/usr/local/runit/bin:$PATH' >> $HOME/.bash_profile
```
