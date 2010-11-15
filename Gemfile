source :rubygems

gem 'bundler', "~>1.0.0"
gem 'rails', "3.0.1"
gem 'paperclip', "2.3.5"
gem 'will_paginate'
gem 'authlogic', :git => 'git://github.com/binarylogic/authlogic.git'
gem 'haml'
gem 'factory_girl'
gem 'faker'
gem 'cancan', "~>1.3.0"

group :pre_boot do
  gem 'refraction'
end

group :development, :test do
  gem 'sqlite3-ruby'
  gem 'pg'
  gem 'awesome_print', :require => 'ap'
  gem 'heroku'
  gem 'rspec', "~>2.1.0", :require => false
  gem 'rspec-rails', "~>2.1.0", :require => false
  gem 'timecop'
end

group :production do
  gem 'hoptoad_notifier'
  gem 'aws-s3'
end

