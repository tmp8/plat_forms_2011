#!/bin/bash -l
vncserver :1 -geometry 1280x1024 -depth 24 -alwaysshared
export DISPLAY=:1
export COVERAGE=true
rvm use 1.9.2@plat_forms_2011 --create
ruby /var/lib/hudson/create_database_config.rb
bundle install
bundle check
rake db:drop:all
rake db:create:all
rake db:migrate
rake db:test:prepare
rake
