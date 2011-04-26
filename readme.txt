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

### Other requirements
create config/initializers/mongo.rb
