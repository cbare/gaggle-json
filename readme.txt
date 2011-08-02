Gaggle-JSON
===========

A demonstration of the Gaggle-JSON format. Store and retrieve Gaggle JSON
documents through a restful interface. Group Gaggle data objects into
projects.


installation notes
------------------
### MongoDB
	sudo port install mongodb
	mongod --dbpath ...path.../gaggle-json/db/mongo/

### Gems
Requires Rails 3, (edit Gemfile to specify rails version 3.0.+) and json
which should already be installed.
	sudo gem install rails --version 3.0.6
	sudo gem install SystemTimer
	sudo gem install tzinfo
	sudo gem install bson_ext
	sudo gem install mongo_mapper
	sudo gem install bson_ext
	sudo gem install rails3-generators
	sudo gem install bluecloth

### Other requirements
create config/initializers/mongo.rb

### Deploying on bragi
bragi has passenger-2.2.9
gem --version = 1.3.5
rails --version Rails 2.3.8
gems are in /local/ruby/lib/ruby/gems/1.9.1/gems/

gem install passenger

gem install bundler
bundle install



installation log
----------------

### install bundler
/local/ruby/bin/gem install bundler
ERROR:  Error installing bundler: bundler requires RubyGems version >= 1.3.6

### gotta update gems first
gem update --system
# didn't work first time:
# RubyGems installed the following executables:
#   /local/ruby/lib/ruby/gems/1.9.1/gems/rubygems-update-1.3.5/bin/gem

gem update --system -V
# worked!
# RubyGems installed the following executables:
#  /local/ruby/bin/gem

### OK, now install bundler
./bin/gem install bundler

### run bundler in /local/rails_apps/gaggle-json/current
export PATH=${PATH}:/local/ruby/bin
/local/ruby/lib/ruby/gems/1.9.1/gems/bundler-1.0.15/bin/bundle install

make
gcc -I. -I/local/ruby/include/ruby-1.9.1/x86_64-linux -I/local/ruby/include/ruby-1.9.1/ruby/backward -I/local/ruby/include/ruby-1.9.1 -I.   -fPIC  -O2 -g -Wall -Wno-parentheses  -o system_timer_native.o -c system_timer_native.c
In file included from system_timer_native.c:8:
/local/ruby/include/ruby-1.9.1/ruby/backward/rubysig.h:14:2: warning: #warning rubysig.h is obsolete
system_timer_native.c: In function ‘install_ruby_sigalrm_handler’:
system_timer_native.c:211: error: ‘rb_thread_critical’ undeclared (first use in this function)
system_timer_native.c:211: error: (Each undeclared identifier is reported only once
system_timer_native.c:211: error: for each function it appears in.)
system_timer_native.c: In function ‘restore_original_ruby_sigalrm_handler’:
system_timer_native.c:217: error: ‘rb_thread_critical’ undeclared (first use in this function)
make: *** [system_timer_native.o] Error 1

# SystemTimer not needed on ruby 1.9, remove from Gemfile

== took a long hiatus at this point ============================================

== realized that I had broken Echidna by upgrading rubygems.
Echidna needs rails 2.3.5 (due to blacklight) and therefore needs rubygems < 1.7
Fixed broken echidna by downgrading gems to 1.6.2:
/local/ruby/bin/gem install rubygems-update -v='1.6.2'
/local/ruby/bin/gem uninstall rubygems-update -v='1.8.5'
update_rubygems
sudo /local/apache2/bin/apachectl restart

== tried bundler again
/local/ruby/bin/bundle install
ERROR: Failed to build gem native extension
http11.c: In function ‘http_field’:
http11.c:77: error: ‘struct RString’ has no member named ‘ptr’

== tried using mongodb on my own machine
ruby/gems/1.9.1/gems/mongo_mapper-0.9.1/lib/mongo_mapper/document.rb
NameError: uninitialized constant Project::Plugins

asked question here: http://groups.google.com/group/mongomapper
got the word that ruby 1.9.1 is badly broken

decided to disable parts of the app that use mongodb, rather than fuss with installing it.
branched to no_mongo

